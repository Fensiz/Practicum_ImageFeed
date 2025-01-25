//
//  ViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 23.01.2025.
//

import UIKit

final class ImageListViewController: UIViewController {

	@IBOutlet weak private var tableView: UITableView!

	private let photosName: [String] = Array(0..<20).map{ "\($0)" }
	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = 200
		tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
	}
}

extension ImageListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		photosName.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
		
		guard let imageListCell = cell as? ImageListCell else {
			return UITableViewCell()
		}

		configCell(for: imageListCell, row: indexPath.row)

		return imageListCell
	}
}

extension ImageListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let image = UIImage(named: photosName[indexPath.row]) else {
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

extension ImageListViewController {
	private func configCell(for cell: ImageListCell, row: Int) {
		cell.cellImage.image = UIImage(named: "\(photosName[row])")
		cell.dateLabel.text = dateFormatter.string(from: Date())
		cell.isLiked = row % 2 == 0
	}
}
