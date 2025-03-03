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
