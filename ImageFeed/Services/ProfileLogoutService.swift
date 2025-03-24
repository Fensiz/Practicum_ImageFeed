//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 22.03.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
	static let shared = ProfileLogoutService()

	private init() { }

	func logout() {
		OAuth2TokenStorage.shared.token = nil
		cleanCookies()
	}

	private func cleanCookies() {
		// Очищаем все куки из хранилища
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		// Запрашиваем все данные из локального хранилища
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			// Массив полученных записей удаляем из хранилища
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
			}
		}
	}
}

