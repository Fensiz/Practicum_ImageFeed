//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 05.04.2025.
//

@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
	var loadCalled: Bool = false
	var presenter: (any ImageFeed.WebViewPresenterProtocol)?
	
	func load(request: URLRequest) {
		loadCalled = true
	}
	
	func setProgressValue(_ newValue: Float) {

	}
	
	func setProgressHidden(_ isHidden: Bool) {

	}
}
