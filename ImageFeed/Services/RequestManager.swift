//
//  RequestManager.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.03.2025.
//

import Foundation

enum RequestManager {
	static func createApiRequest(
		with token: String?,
		for path: String,
		using baseURL: URL = Constants.defaultBaseURL,
		page: Int? = nil,
		perPage: Int? = nil
	) -> Result<URLRequest, ServiceError> {

		guard let token else {
			return .failure(.missingToken)
		}

		var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
		urlComponents?.path = "/\(path)"

		if let page, let perPage {
			urlComponents?.queryItems = [
				URLQueryItem(name: "page", value: String(page)),
				URLQueryItem(name: "per_page", value: String(perPage)),
			]
		}

		guard let url = urlComponents?.url else {
			return .failure(.invalidURL)
		}

		var request = URLRequest(url: url)
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		return .success(request)
	}

	static func makeOAuthTokenRequest(with code: String) -> Result<URLRequest, ServiceError> {
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
			URLQueryItem(name: "code", value: code),
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
