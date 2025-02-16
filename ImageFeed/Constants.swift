//
//  Constants.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 15.02.2025.
//

import Foundation

enum Constants {
	static let accessKey = KeysManager.shared.get("ACCESS_KEY") ?? ""
	static let secretKey = KeysManager.shared.get("SECRET_KEY") ?? ""
	static let accessScope = "public+read_user+write_likes"
	static let redirectURI = KeysManager.shared.get("REDIRECT_URI") ?? ""
	static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
}
