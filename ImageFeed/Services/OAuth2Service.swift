//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation

final class OAuth2Service {

	enum OAuth2Error: Error {
		case networkError(URLSession.NetworkError)
		case decodeError
	}

	// MARK: - Static Properties

	static let shared = OAuth2Service()

	// MARK: - Initializers

	private init() {}

	// MARK: - Public Methods

	func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, OAuth2Error>) -> Void) {
		let request = makeOAuthTokenRequest(code: code)

		URLSession.shared.data(for: request) { result in
			switch result {
				case .failure(let error):
					completion(.failure(.networkError(error)))
				case .success(let data):
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					do {
						let body = try decoder.decode(OAuthTokenResponseBody.self, from: data)
						completion(.success(body.accessToken))
					} catch {
						completion(.failure(.decodeError))
					}
			}
		}.resume()
	}

	// MARK: - Private Methods

	private func makeOAuthTokenRequest(code: String) -> URLRequest {
		guard let baseURL = URL(string: "https://unsplash.com") else {
			fatalError("Не удалось создать URL")
		}

		var urlComponents = URLComponents()
		urlComponents.scheme = baseURL.scheme
		urlComponents.host = baseURL.host
		urlComponents.path = "/oauth/token"
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.accessKey),
			URLQueryItem(name: "client_secret", value: Constants.secretKey),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
			URLQueryItem(name: "code", value: code),
			URLQueryItem(name: "grant_type", value: "authorization_code")
		]

		guard let url = urlComponents.url else {
			fatalError("Не удалось создать URL")
		}

		var request = URLRequest(url: url)
		request.setHttpMethod(.post)

		return request
	}
}
