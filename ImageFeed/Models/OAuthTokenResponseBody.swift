//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

struct OAuthTokenResponseBody: Decodable {
	let accessToken, tokenType, scope: String
	let createdAt: Int
}
