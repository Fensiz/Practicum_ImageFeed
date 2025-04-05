//
//  Constants.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 15.02.2025.
//

import Foundation

enum Constants {
	static let accessKey = "KwON6OY_KKUCGDBh1Dj2OuT4e2S8BEhUV7mXHf1YeSs"
	static let secretKey = "PMHkSs9RWBw91Yfb7HpHrL4aF5GRXUb53U_aN8eqGro"
	static let accessScope = "public+read_user+write_likes"
	static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
	static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
	static let defaultBaseURL: URL = {
		guard let url = URL(string: "https://api.unsplash.com/") else {
			fatalError("Не удалось создать URL")
		}
		return url
	}()
}

struct AuthConfiguration {
	let accessKey: String
	let secretKey: String
	let redirectURI: String
	let accessScope: String
	let defaultBaseURL: URL
	let authURLString: String

	init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
		self.accessKey = accessKey
		self.secretKey = secretKey
		self.redirectURI = redirectURI
		self.accessScope = accessScope
		self.defaultBaseURL = defaultBaseURL
		self.authURLString = authURLString
	}

	static var standard: AuthConfiguration {
		AuthConfiguration(
			accessKey: Constants.accessKey,
			secretKey: Constants.secretKey,
			redirectURI: Constants.redirectURI,
			accessScope: Constants.accessScope,
			authURLString: Constants.unsplashAuthorizeURLString,
			defaultBaseURL: Constants.defaultBaseURL
		)
	}
}
