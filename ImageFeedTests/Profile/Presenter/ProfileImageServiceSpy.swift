//
//  ImageListServiceSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

@testable import ImageFeed

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
	var avatarURL: String?
	
	func fetchProfileImageURL(for username: String, with token: String, _ completion: @escaping (Result<String, ImageFeed.ServiceError>) -> Void) {
		
	}
}
