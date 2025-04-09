//
//  Untitled.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 05.04.2025.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
	var viewDidLoadCalled: Bool = false
	var view: WebViewViewControllerProtocol?

	func viewDidLoad() {
		viewDidLoadCalled = true
	}

	func didUpdateProgressValue(_ newValue: Double) {

	}

	func code(from url: URL) -> String? {
		return nil
	}
}
