//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

protocol ProfileImageServiceProtocol {
	var avatarURL: String? { get }

	func fetchProfileImageURL(
		for username: String,
		with token: String,
		_ completion: @escaping (Result<String, ServiceError>) -> Void
	)
}
