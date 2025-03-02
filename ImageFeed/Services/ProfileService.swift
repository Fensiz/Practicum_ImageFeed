//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 01.03.2025.
//

import Foundation

final class ProfileService {
	static let shared = ProfileService()
	private let decoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()

	private init() {}

	private(set) var profile: Profile?
	private var task: URLSessionTask?

	func fetchProfile(_ token: String, completion: @escaping (Result<Profile, ServiceError>) -> Void) {
		let urlRequest: URLRequest
		let result = RequestManager.createApiRequest(with: token, for: "me")
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

		self.task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<ProfileResult, ServiceError>) in
			switch result {
				case .success(let profileResult):
					let profile = Profile(result: profileResult)
					self?.profile = profile
					ProfileImageService.shared.fetchProfileImageURL(for: profileResult.username, with: token) { _ in
						completion(.success(profile))
					}
				case .failure(let error):
					ServiceError.log(error: error)
					completion(.failure(error))
			}
			self?.task = nil
		}

		task?.resume()
	}
}
