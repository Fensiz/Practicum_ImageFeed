//
//  ServiceError.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.03.2025.
//

import Foundation

enum ServiceError: Error {
	case urlSessionError
	case networkError(Error)
	case requestError(Error)
	case httpStatusCode(Int)
	case urlRequestError(Error)
	case decodingError(Data, Error)
	case invalidURL
	case missingToken
	case invalidRequest

	static func log(
		error: ServiceError,
		file: String = #file,
		line: UInt = #line,
		function: String = #function
	) {
		var message = "<нет информации>"

		switch error {
			case .invalidURL:
				message = "Ошибка при создании URL"
			case .urlRequestError(let error):
				message = "Ошбика запроса: \(error.localizedDescription)"
			case .urlSessionError:
				message = "Ошибка URLSession"
			case .networkError(let error):
				message = "Ошибка сети: \(error.localizedDescription)"
			case .requestError(let error):
				message = "Ошибка создание запроса: \(error.localizedDescription)"
			case .httpStatusCode(let code):
				message = "Ошибка HTTP(code: \(code)"
			case .decodingError(let data, let error):
				message = "Ошибка декодирования: \(error.localizedDescription), \nданные: \n\(String(data: data, encoding: .utf8) ?? "нет данных")"
			case .missingToken:
				message = "Не передан токен"
			case .invalidRequest:
				message = "Выполнен запрос с предыдущим кодом"
		}
		print("[\((file as NSString).lastPathComponent) - \(function) - Line \(line)] Ошибка: \(message)")
	}
}

