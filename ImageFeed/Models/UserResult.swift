//
//  UserResult.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 01.03.2025.
//

import Foundation

struct UserResult: Decodable {
	let id: String
	let updatedAt: String
	let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
	let small, medium, large: String
}

//struct Badge: Decodable {
//	let title: String?
//	let primary: Bool
//	let slug: String?
//	let link: String?
//}
//
//struct Links: Decodable {
//	let `self`: String?
//	let html: String?
//	let photos: String?
//	let likes: String?
//	let portfolio: String?
//}
//
//struct Social: Decodable {
//	let instagramUsername, portfolioURL, twitterUsername: String?
//}
