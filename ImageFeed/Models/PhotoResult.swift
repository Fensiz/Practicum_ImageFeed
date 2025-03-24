//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 24.03.2025.
//

struct PhotoResult: Decodable {
	let id: String
	let width: Int
	let height: Int
	let createdAt: String
	let description: String?
	let urls: UrlsResult
	let likedByUser: Bool
}
