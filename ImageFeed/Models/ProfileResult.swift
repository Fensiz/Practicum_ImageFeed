//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 01.03.2025.
//

import Foundation

struct ProfileResult: Decodable {
	let id: String
	let updatedAt: String
	let username: String
	let firstName: String?
	let lastName: String?
	let portfolioURL: String?
	let bio: String?
}
