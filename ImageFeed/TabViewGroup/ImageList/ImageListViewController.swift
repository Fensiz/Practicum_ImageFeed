//
//  ViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 23.01.2025.
//

import UIKit

final class ImageListViewController: UIViewController {

	// MARK: - Public Properties

	var presenter: ImageListPresenterProtocol?

	// MARK: - UI Elements

	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.register(ImageListCell.self)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.accessibilityIdentifier = AccessibilityIds.imageListTableView
		return tableView
	}()

	// MARK: - Overrides Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()

		presenter?.viewDidLoad()
	}

	private func setupUI() {
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
	}
}

// MARK: - DataSource

extension ImageListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter?.photos.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let imageListCell = tableView.reuse(ImageListCell.self, indexPath),
			  let presenter else {
			return UITableViewCell()
		}
		let photo = presenter.photos[indexPath.row]
		let dateText = presenter.dateText(for: photo)
		imageListCell.config(
			with: URL(string: photo.thumbImageURL),
			dateText: dateText,
			isLiked: photo.isLiked
		)
		imageListCell.delegate = self

		return imageListCell
	}
}

// MARK: - TableView Delegate

extension ImageListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let photo = presenter?.photos[indexPath.row] else { return 0 }

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
		return max(cellHeight, 0)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.didSelect(at: indexPath)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		presenter?.willDisplayCell(at: indexPath)
	}
}

// MARK: - Cell Delegate

extension ImageListViewController: ImageListCellDelegate {
	func didTapLikeButton(on cell: ImageListCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		presenter?.didTapLike(at: indexPath)
	}
}

// MARK: - View Protocol

extension ImageListViewController: ImageListViewProtocol {
	func updateTable(in range: Range<Int>) {
		tableView.performBatchUpdates {
			let indexPaths = range.map { i in
				IndexPath(row: i, section: 0)
			}
			tableView.insertRows(at: indexPaths, with: .automatic)
		} completion: { _ in }
	}

	func showError(_ error: Error) {
		let alert = UIAlertController(
			title: "Ошибка",
			message: error.localizedDescription,
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "ОК", style: .default))
		present(alert, animated: true)
	}

	func reloadCell(at indexPath: IndexPath) {
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}

	//наверно надо вынести в координатор, когда тот появится
	func showFullImage(for photo: Photo) {
		let vc = SingleImageViewController()
		vc.image = photo
		vc.modalPresentationStyle = .fullScreen
		present(vc, animated: true)
	}

	func showLoading() {
		UIBlockingProgressHUD.show()
	}

	func hideLoading() {
		UIBlockingProgressHUD.dismiss()
	}
}
