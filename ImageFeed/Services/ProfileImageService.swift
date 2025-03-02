//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 01.03.2025.
//

import Foundation

final class ProfileImageService {
	static let shared = ProfileImageService()
	private init() {}
	
	// MARK: - Private Properties

	private var task: URLSessionTask?
	private(set) var avatarURL: String?

	static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

	func fetchProfileImageURL(
		for username: String,
		with token: String,
		_ completion: @escaping (Result<String, ServiceError>) -> Void
	) {
		let urlRequest: URLRequest
		let result = RequestManager.createApiRequest(with: token, for: "users/\(username)")
		switch result {
			case .success(let request):
				urlRequest = request
			case .failure(let error):
				ServiceError.log(error: error)
				completion(.failure(error))
				return
		}

		if let task {
			task.cancel()
		}

		task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<UserResult, ServiceError>) in
			switch result {
				case .success(let user):
					let small = user.profileImage.small
					self?.avatarURL = small
					completion(.success(small))
					NotificationCenter.default.post(
						name: ProfileImageService.didChangeNotification,
						object: self,
						userInfo: ["URL": small]
					)
				case .failure(let error):
					ServiceError.log(error: error)
					completion(.failure(error))
			}
			self?.task = nil
		}

		task?.resume()
	}
}
