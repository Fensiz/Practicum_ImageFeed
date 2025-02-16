//
//  KeyManager.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation

final class KeysManager {
	static let shared = KeysManager()
	private var keys: [String: Any] = [:]

	private init() {
		if let url = Bundle.main.url(forResource: "keys", withExtension: "plist"),
		   let data = try? Data(contentsOf: url) {
			keys = (try? PropertyListSerialization.propertyList(from: data, format: nil)) as? [String: Any] ?? [:]
		}
	}

	func get(_ key: String) -> String? {
		return keys[key] as? String
	}
}
