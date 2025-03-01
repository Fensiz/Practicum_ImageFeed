//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation

extension URLRequest {
	enum HTTPMethod: String {
		case get
		case post
	}
	mutating func setHttpMethod(_ method: HTTPMethod) {
		httpMethod = method.rawValue
	}
}
