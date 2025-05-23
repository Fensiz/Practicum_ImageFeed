//
//  Photo.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 20.03.2025.
//

import Foundation

struct Photo: Decodable {
	static let formatter = ISO8601DateFormatter()

	let id: String
	let size: CGSize
	let createdAt: Date?
	let welcomeDescription: String?
	let thumbImageURL: String
	let largeImageURL: String
	let isLiked: Bool

	init(
		id: String,
		size: CGSize,
		createdAt: Date?,
		welcomeDescription: String?,
		thumbImageURL: String,
		largeImageURL: String,
		isLiked: Bool
	) {
		self.id = id
		self.size = size
		self.createdAt = createdAt
		self.welcomeDescription = welcomeDescription
		self.thumbImageURL = thumbImageURL
		self.largeImageURL = largeImageURL
		self.isLiked = isLiked
	}

	init(_ photo: PhotoResult) {
		id = photo.id
		size = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
		createdAt = Photo.formatter.date(from: photo.createdAt)
		welcomeDescription = photo.description
		thumbImageURL = photo.urls.small
		largeImageURL = photo.urls.full
		isLiked = photo.likedByUser
	}
}
