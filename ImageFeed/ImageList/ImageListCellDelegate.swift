//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.02.2025.
//

protocol ImageListCellDelegate: AnyObject {
	func didTapLikeButton(on cell: ImageListCell)
}
