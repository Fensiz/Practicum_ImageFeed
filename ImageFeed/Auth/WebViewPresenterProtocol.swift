//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 04.04.2025.
//

import Foundation

protocol WebViewPresenterProtocol {
	var view: WebViewViewControllerProtocol? { get set }
	func viewDidLoad()
	func didUpdateProgressValue(_ newValue: Double)
	func code(from url: URL) -> String?
}
