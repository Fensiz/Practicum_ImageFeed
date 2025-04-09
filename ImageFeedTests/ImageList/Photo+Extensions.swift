//
//  Photo+Extensions.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

@testable import ImageFeed
import Foundation

extension Photo {
	static let mock = Photo(
		id: "mock_id",
		size: CGSize(width: 200, height: 100),
		createdAt: Date(timeIntervalSince1970: 0),
		welcomeDescription: "Test description",
		thumbImageURL: "https://example.com/thumb.jpg",
		largeImageURL: "https://example.com/large.jpg",
		isLiked: false
	)
}
