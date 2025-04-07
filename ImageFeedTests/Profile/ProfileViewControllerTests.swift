//
//  ProfileViewControllerTests.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import XCTest
@testable import ImageFeed
import Kingfisher

class ProfileViewControllerTests: XCTestCase {
	func test_switchToSplash_changesRootViewController() {
		// Given
		let sut = ProfileViewController()
		let window = UIApplication.shared.windows.first

		// When
		sut.switchToSplash()

		// Then
		XCTAssertTrue(window?.rootViewController is SplashScreenViewController)
	}
}
