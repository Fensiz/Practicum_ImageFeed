//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 05.04.2025.
//

import Foundation

protocol AuthHelperProtocol {
	var authUrlRequest: URLRequest? { get }
	func getCode(from url: URL) -> String?
}
