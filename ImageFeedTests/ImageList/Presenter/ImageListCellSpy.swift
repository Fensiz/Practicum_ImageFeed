//
//  Untitled.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

@testable import ImageFeed
import Foundation
import UIKit

final class ImageListCellSpy: ImageListCellProtocol {
	var configCalled = false
	var dateText: String?
	var isLiked: Bool?

	func config(with url: URL?, dateText: String, isLiked: Bool) {
		configCalled = true
		self.dateText = dateText
		self.isLiked = isLiked
	}
}
