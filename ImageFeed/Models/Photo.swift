//
//  Photo.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 20.03.2025.
//

import Foundation

struct Photo: Decodable {
	let id: String
	let size: CGSize
	let createdAt: Date?
	let welcomeDescription: String?
	let thumbImageURL: String
	let largeImageURL: String
	let isLiked: Bool

	init(_ photo: PhotoResult) {
		id = photo.id
		size = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
		createdAt = ISO8601DateFormatter().date(from: photo.createdAt)
		welcomeDescription = photo.description
		thumbImageURL = photo.urls.small
		largeImageURL = photo.urls.raw
		isLiked = photo.likedByUser
	}
}

struct PhotoResult: Decodable {
	let id: String
	let width: Int
	let height: Int
	let createdAt: String
	let description: String?
	let urls: URLs
	let likedByUser: Bool
}

struct URLs: Decodable {
	let raw: String
	let small: String
}
