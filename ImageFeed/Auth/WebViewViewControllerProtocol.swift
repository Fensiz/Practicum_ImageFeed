//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 05.04.2025.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
	var presenter: WebViewPresenterProtocol? { get set }
	func load(request: URLRequest)
	func setProgressValue(_ newValue: Float)
	func setProgressHidden(_ isHidden: Bool)
}
