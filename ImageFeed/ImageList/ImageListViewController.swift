//
//  ViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 23.01.2025.
//

import UIKit

final class ImageListViewController: UIViewController {

	// MARK: - IB Outlets

	@IBOutlet weak private var tableView: UITableView!

	// MARK: - Private Properties

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
	}
}

extension ImageListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		photos.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let imageListCell = tableView.dequeueReusableCell(
			withIdentifier: ImageListCell.reuseIdentifier,
			for: indexPath
		) as? ImageListCell else {
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

extension ImageListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let image = UIImage(named: photos[indexPath.row].name) else {
			return 0
		}

		let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
		let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
		let imageWidth = image.size.width
		let scale = imageViewWidth / imageWidth
		let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
		return cellHeight
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
