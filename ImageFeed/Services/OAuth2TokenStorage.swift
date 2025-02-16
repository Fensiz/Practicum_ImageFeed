//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation

final class OAuth2TokenStorage {
	static let shared = OAuth2TokenStorage()
	private init() {}

	private let tokenKey = "oauth2Token"

	var token: String? {
		get {
			UserDefaults.standard.string(forKey: tokenKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: tokenKey)
		}
	}
}
