//
//  ViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 23.01.2025.
//

import UIKit

final class ImageListViewController: UIViewController {

	// MARK: - UI Elements

	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.register(ImageListCell.self)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	// MARK: - Private Properties

	private let showSingleImageSegueIdentifier = "ShowSingleImage"
	private var photos: [(name: String, isLiked: Bool)] = Array(0..<20).map{ ("\($0)", $0 % 2 == 0) }
	private let currentDate = Date()
	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()

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

		imageListCell.config(
			with: UIImage(named: photos[indexPath.row].name),
			dateText: dateFormatter.string(from: currentDate),
			isLiked: photos[indexPath.row].isLiked
		)
		imageListCell.delegate = self

		return imageListCell
	}
}

// MARK: - Delegate

extension ImageListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let image = UIImage(named: photos[indexPath.row].name) else {
			return 0
		}

		let imageInsets = UIEdgeInsets(
			top: UIConstants.smallOffset / 2,
			left: UIConstants.offset,
			bottom: UIConstants.smallOffset / 2,
			right: UIConstants.offset
		)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		let imageWidth = image.size.width
		let scale = imageViewWidth / imageWidth
		let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
		return cellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = SingleImageViewController()
		vc.image = UIImage(named: photos[indexPath.row].name) ?? UIImage()
		vc.modalPresentationStyle = .fullScreen
		present(vc, animated: true)
	}
}

extension ImageListViewController: ImageListCellDelegate {
	func didTapLikeButton(on cell: ImageListCell) {
		if let indexPath = tableView.indexPath(for: cell) {
			photos[indexPath.row].isLiked.toggle()
			tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
}
