//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

	static let shared = OAuth2TokenStorage()

	private init() {}

	private let tokenKey = "oauth2Token"

	var token: String? {
		get {
			KeychainWrapper.standard.string(forKey: tokenKey)
//			UserDefaults.standard.string(forKey: tokenKey)
		}
		set {
			if let newValue {
				KeychainWrapper.standard.set(newValue, forKey: tokenKey)
			} else {
				KeychainWrapper.standard.removeObject(forKey: tokenKey)
			}
		}
	}
}
