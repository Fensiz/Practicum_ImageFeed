//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 25.01.2025.
//

import UIKit

final class ImageListCell: UITableViewCell {

	static let reuseIdentifier = "ImageListCell"

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var cellImage: UIImageView!

	@IBAction func likeButtonAction(_ sender: UIButton) {
		isLiked.toggle()
	}
	
	var isLiked: Bool = false {
		didSet {
			likeButton.tintColor = isLiked ? .ypRed : .ypWhite50
		}
	}
}
