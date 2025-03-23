//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation

final class OAuth2Service {

	// MARK: - Static Properties

	static let shared = OAuth2Service()

	// MARK: - Private Properties

	private var task: URLSessionTask?
	private var lastCode: String?

	// MARK: - Initializers

	private init() {}

	// MARK: - Public Methods

	func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, ServiceError>) -> Void) {
		assert(Thread.isMainThread)
		guard lastCode != code else {
			ServiceError.log(error: .invalidRequest)
			completion(.failure(.invalidRequest))
			return
		}

		task?.cancel()
		lastCode = code

		let urlRequest: URLRequest
		let result = RequestManager.makeOAuthTokenRequest(with: code)
		switch result {
			case .success(let request):
				urlRequest = request
			case .failure(let error):
				ServiceError.log(error: error)
				completion(.failure(error))
				return
		}

		task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<OAuthTokenResponseBody, ServiceError>) in
			guard let self else { return }
			switch result {
				case .success(let tokenBody):
					let token = tokenBody.accessToken
					completion(.success(token))
				case .failure(let error):
					ServiceError.log(error: error)
					completion(.failure(error))
			}
			assert(Thread.isMainThread)
			self.task = nil
			self.lastCode = nil
		}

		task?.resume()
	}
}
