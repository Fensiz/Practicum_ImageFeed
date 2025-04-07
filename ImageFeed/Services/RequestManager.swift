//
//  RequestBuilder.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 22.03.2025.
//

import Foundation

enum RequestManager {
	static func getPhotos(with token: String, page: Int? = nil, perPage: Int? = nil) -> Result<URLRequest, ServiceError> {
		let builder = RequestBuilder()
			.setToken(token)
			.setPath("photos")
		if let page = page, let perPage = perPage {
			assert(page > 0, "Page must be positive")
			assert(perPage > 0, "Per page must be positive")
			_ = builder
				.addQueryItem(name: "page", value: "\(page)")
				.addQueryItem(name: "per_page", value: "\(perPage)")
		}
		
		return builder
			.build()
	}

	static func makeOAuthTokenRequest(with code: String) -> Result<URLRequest, ServiceError> {
		guard let url = URL(string: "https://unsplash.com") else {
			return .failure(.invalidURL)
		}
		return RequestBuilder(baseURL: url)
			.setPath("oauth/token")
			.addQueryItem(name: "client_id", value: Constants.accessKey)
			.addQueryItem(name: "client_secret", value: Constants.secretKey)
			.addQueryItem(name: "redirect_uri", value: Constants.redirectURI)
			.addQueryItem(name: "code", value: code)
			.addQueryItem(name: "grant_type", value: "authorization_code")
			.setHttpMethod(.post)
			.build()
	}

	static func getUser(_ user: String, with token: String?) -> Result<URLRequest, ServiceError> {
		guard let token else {
			return .failure(.missingToken)
		}
		return RequestBuilder()
			.setToken(token)
			.setPath("users/\(user)")
			.build()
	}

	static func getProfile(with token: String?) -> Result<URLRequest, ServiceError> {
		guard let token else {
			return .failure(.missingToken)
		}
		return RequestBuilder()
			.setToken(token)
			.setPath("me")
			.build()
	}

	static func likePhoto(token: String?, id: String) -> Result<URLRequest, ServiceError> {
		guard let token else {
			return .failure(.missingToken)
		}
		return RequestBuilder()
			.setToken(token)
			.setPath("photos/\(id)/like")
			.setHttpMethod(.post)
			.build()
	}

	static func unlikePhoto(token: String?, id: String) -> Result<URLRequest, ServiceError> {
		guard let token else {
			return .failure(.missingToken)
		}
		return RequestBuilder()
			.setToken(token)
			.setPath("photos/\(id)/like")
			.setHttpMethod(.delete)
			.build()
	}
}

enum HttpMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
	case patch = "PATCH"
}

fileprivate final class RequestBuilder {
	private var urlComponents: URLComponents
	private var httpMethod: HttpMethod = .get
	private var headers: [String: String] = [:]
	private var body: Data?

	init(baseURL: URL = Constants.defaultBaseURL) {
		self.urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) ?? URLComponents()
	}

	func setPath(_ path: String) -> Self {
		urlComponents.path = "/\(path)"
		return self
	}

	func setToken(_ token: String) -> Self {
		headers["Authorization"] = "Bearer \(token)"
		return self
	}

	func addQueryItem(name: String, value: String?) -> RequestBuilder {
		guard let value else { return self }
		if urlComponents.queryItems == nil {
			urlComponents.queryItems = []
		}
		urlComponents.queryItems?.append(URLQueryItem(name: name, value: value))
		return self
	}

	func setHttpMethod(_ method: HttpMethod) -> RequestBuilder {
		self.httpMethod = method
		return self
	}

	func addHeader(name: String, value: String) -> RequestBuilder {
		headers[name] = value
		return self
	}

	func setBody(_ data: Data?) -> RequestBuilder {
		self.body = data
		return self
	}

	func build() -> Result<URLRequest, ServiceError> {
		guard let url = urlComponents.url else {
			return .failure(.invalidURL)
		}

		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
		request.httpBody = body

		return .success(request)
	}
}
