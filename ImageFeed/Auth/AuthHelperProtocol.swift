//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 05.04.2025.
//

import Foundation

protocol AuthHelperProtocol {
	func authRequest() -> URLRequest?
	func code(from url: URL) -> String?
}
