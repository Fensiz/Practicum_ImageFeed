//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Симонов Иван Дмитриевич on 05.04.2025.
//

@testable import ImageFeed
import XCTest

final class ImageFeedTests: XCTestCase {

	func testViewControllerCallsViewDidLoad() {
		//given
		let viewController = WebViewViewController()
		let presenter = WebViewPresenterSpy()
		viewController.presenter = presenter
		presenter.view = viewController

		//when
		_ = viewController.view

		//then
		XCTAssertTrue(presenter.viewDidLoadCalled)
	}

	// MARK: - Progress

	func testPresenterCallsLoadRequest() {
		//given
		let viewController = WebViewViewControllerSpy()
		let presenter = WebViewPresenter(authHelper: AuthHelper())
		viewController.presenter = presenter
		presenter.view = viewController

		//when
		presenter.viewDidLoad()

		//then
		XCTAssertTrue(viewController.loadCalled)
	}

	func testProgressVisibleWhenLessThenOne() {
		//given
		let authHelper = AuthHelper()
		let presenter = WebViewPresenter(authHelper: authHelper)
		let progress: Float = 0.6

		//when
		let shouldHideProgress = presenter.shouldHideProgress(for: progress)

		//then
		XCTAssertFalse(shouldHideProgress)
	}

	func testProgressHiddenWhenEqualOne() {
		//given
		let authHelper = AuthHelper()
		let presenter = WebViewPresenter(authHelper: authHelper)
		let progress: Float = 1.0

		//when
		let shouldHideProgress = presenter.shouldHideProgress(for: progress)

		//then
		XCTAssertTrue(shouldHideProgress)
	}

	// MARK: - AuthHelper

	func testAuthHelperAuthURL() {
		//given
		let configuration = AuthConfiguration.standard
		let authHelper = AuthHelper(configuration: configuration)

		//when
		let url = authHelper.authURL()

		guard let urlString = url?.absoluteString else {
			XCTFail("Auth URL is nil")
			return
		}

		//then
		XCTAssertTrue(urlString.contains(configuration.authURLString))
		XCTAssertTrue(urlString.contains(configuration.accessKey))
		XCTAssertTrue(urlString.contains(configuration.redirectURI))
		XCTAssertTrue(urlString.contains("code"))
		XCTAssertTrue(urlString.contains(configuration.accessScope))
	}

	func testAuthHelperGettingCodeFromUrl() {
		//given
		let expectedCode = "test code"
		let authHelper = AuthHelper()
		var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
		urlComponents.queryItems = [
			URLQueryItem(name: "code", value: expectedCode)
		]

		//when
		let code = authHelper.getCode(from: urlComponents.url!)

		//then
		XCTAssertEqual(code, expectedCode)
	}
}
