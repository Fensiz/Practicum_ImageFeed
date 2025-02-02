//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 25.01.2025.
//

import UIKit

final class ImageListCell: UITableViewCell {

	// MARK: - Static Properties

	static let reuseIdentifier = "ImageListCell"

	// MARK: - IB Outlets

	@IBOutlet weak private var dateLabel: UILabel!
	@IBOutlet weak private var likeButton: UIButton!
	@IBOutlet weak private var cellImage: UIImageView!

	// MARK: - Public Properties

	weak var delegate: ImageListCellDelegate?

	// MARK: - Private Properties

	private var isLiked: Bool = false {
		didSet {
			likeButton.tintColor = isLiked ? .ypWhite50 : .ypRed
		}
	}

	// MARK: - IB Actions

	@IBAction private func likeButtonTapped() {
		delegate?.didTapLikeButton(on: self)
	}

	// MARK: - Public Methods

	func config(with image: UIImage?, dateText: String, isLiked: Bool) {
		cellImage.image = image
		dateLabel.text = dateText
		self.isLiked = isLiked
	}
}
