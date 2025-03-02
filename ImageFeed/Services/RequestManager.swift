//
//  RequestManager.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.03.2025.
//

import Foundation

// MARK: - RequestManager

enum RequestManager {
	static func createApiRequest(
		with token: String?,
		for path: String,
		using baseURL: URL = Constants.defaultBaseURL
	) -> Result<URLRequest, ServiceError> {

		guard let token else {
			return .failure(.missingToken)
		}

		var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
		urlComponents?.path = "/\(path)"

		guard let url = urlComponents?.url else {
			return .failure(.invalidURL)
		}

		var request = URLRequest(url: url)
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		return .success(request)
	}

	static func makeOAuthTokenRequest(with: String) -> Result<URLRequest, ServiceError> {
		guard let baseURL = URL(string: "https://unsplash.com") else {
			return .failure(.invalidURL)
		}

		var urlComponents = URLComponents()
		urlComponents.scheme = baseURL.scheme
		urlComponents.host = baseURL.host
		urlComponents.path = "/oauth/token"
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.accessKey),
			URLQueryItem(name: "client_secret", value: Constants.secretKey),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
			URLQueryItem(name: "code", value: with),
			URLQueryItem(name: "grant_type", value: "authorization_code")
		]

		guard let url = urlComponents.url else {
			return .failure(.invalidURL)
		}

		var request = URLRequest(url: url)
		request.setHttpMethod(.post)

		return .success(request)
	}
}
