//
//  ViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 23.01.2025.
//

import UIKit
import ProgressHUD

final class ImageListViewController: UIViewController {

	// MARK: - Public Properties

	var photos: [Photo] = []

	// MARK: - UI Elements

	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.register(ImageListCell.self)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	// MARK: - Private Properties

	private let imageService: ImageListServiceProtocol = ImageListService()
	private let showSingleImageSegueIdentifier = "ShowSingleImage"
	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()
	private var imageServiceObserver: NSObjectProtocol?

	// MARK: - Overrides Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
		view.backgroundColor = .ypBlack
		tableView.backgroundColor = .ypBlack
		tableView.separatorStyle = .none
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
		imageServiceObserver = NotificationCenter.default
			.addObserver(
				forName: ImageListService.didChangeNotification,
				object: nil,
				queue: .main
			) { [weak self] _ in
				guard let self = self else { return }
				self.updateTableViewAnimated()
			}
		imageService.fetchPhotosNextPage { error in
			if let error {
				let alertController = UIAlertController(
					title: "Error",
					message: error.localizedDescription,
					preferredStyle: .alert
				)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
			}
		}
	}

	func updateTableViewAnimated() {
		let oldCount = photos.count
		let newCount = imageService.photos.count
		photos = imageService.photos
		if oldCount != newCount {
			tableView.performBatchUpdates {
				let indexPaths = (oldCount..<newCount).map { i in
					IndexPath(row: i, section: 0)
				}
				tableView.insertRows(at: indexPaths, with: .automatic)
			} completion: { _ in }
		}
	}
}

// MARK: - DataSource

extension ImageListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		photos.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let imageListCell = tableView.reuse(ImageListCell.self, indexPath) else {
			return UITableViewCell()
		}
		let photo = photos[indexPath.row]
		var dateText = "-"
		if let date = photo.createdAt {
			dateText = dateFormatter.string(from: date)
		}
		imageListCell.config(
			with: URL(string: photo.thumbImageURL),
			dateText: dateText,
			isLiked: photo.isLiked
		)
		imageListCell.delegate = self

		return imageListCell
	}
}

// MARK: - Delegate

extension ImageListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let photo = photos[indexPath.row]

		let imageInsets = UIEdgeInsets(
			top: UIConstants.smallOffset / 2,
			left: UIConstants.offset,
			bottom: UIConstants.smallOffset / 2,
			right: UIConstants.offset
		)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		let imageWidth = photo.size.width
		let scale = imageViewWidth / imageWidth
		let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
		return cellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = SingleImageViewController()
		vc.image = photos[indexPath.row]
		vc.modalPresentationStyle = .fullScreen
		present(vc, animated: true)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == photos.count - 1 {
			imageService.fetchPhotosNextPage() { _ in

			}
		}
	}
}

extension ImageListViewController: ImageListCellDelegate {
	func didTapLikeButton(on cell: ImageListCell) {
		if let indexPath = tableView.indexPath(for: cell) {
			let photo = photos[indexPath.row]
			UIBlockingProgressHUD.show()
			imageService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
				switch result {
					case .failure(let error):
						ServiceError.log(error: error)
						UIBlockingProgressHUD.dismiss()
						let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: "ОК", style: .default))

						self?.present(alert, animated: true)
					case .success:
						DispatchQueue.main.async {
							self?.photos = self?.imageService.photos ?? []
							self?.tableView.reloadRows(at: [indexPath], with: .automatic)
							UIBlockingProgressHUD.dismiss()
						}
				}
			}
		}
	}
}
