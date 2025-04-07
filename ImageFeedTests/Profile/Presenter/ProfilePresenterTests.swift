//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterTests: XCTestCase {

	private var presenter: ProfilePresenter!
	private var view: ProfileViewControllerSpy!
	private var profileService: ProfileServiceStub!
	private var profileImageService: ProfileImageServiceSpy!

	override func setUp() {
		view = ProfileViewControllerSpy()
		profileService = ProfileServiceStub()
		profileImageService = ProfileImageServiceSpy()
		presenter = ProfilePresenter(view: view,
									 profileService: profileService,
									 profileImageService: profileImageService)
	}

	override func tearDown() {
		view = nil
		profileService = nil
		profileImageService = nil
		presenter = nil
	}

	func test_viewDidLoad_whenProfileExists_updatesProfileAndAvatar() {
		// Given
		let firstName = "John"
		let lastName = "Doe"
		let profile = Profile(
			result: ProfileResult(
				id: "id",
				updatedAt: "\(Date())",
				username: "john_doe",
				firstName: firstName,
				lastName: lastName,
				portfolioURL: nil,
				bio: "test bio"
			)
		)
		profileService.profile = profile
		profileImageService.avatarURL = "https://example.com/avatar.png"

		// When
		presenter.viewDidLoad()

		// Then
		XCTAssertEqual(view.updateProfileCalls, 1)
		XCTAssertEqual(view.lastProfile?.name, "\(firstName) \(lastName)")

		XCTAssertEqual(view.updateAvatarCalls, 1)
		XCTAssertEqual(view.lastAvatarURL?.absoluteString, "https://example.com/avatar.png")
	}

	func test_viewDidLoad_whenNoProfile_doesNotUpdateProfile() {
		// Given
		profileService.profile = nil

		// When
		presenter.viewDidLoad()

		// Then
		XCTAssertEqual(view.updateProfileCalls, 0)
	}

	func test_didTapLogout_callsShowLogoutConfirmation() {
		// When
		presenter.didTapLogout()

		// Then
		XCTAssertEqual(view.showLogoutConfirmationCalls, 1)
	}

	func test_confirmLogout_callsSwitchToSplash() {
		// When
		presenter.confirmLogout()

		// Then
		XCTAssertEqual(view.switchToSplashCalls, 1)
	}

	func test_setupObserver_shouldCallUpdateAvatarOnNotification() {
		// Given
		profileImageService.avatarURL = "https://example.com/avatar.jpg"

		// When
		NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)

		// Then
		XCTAssertEqual(view.updateAvatarCalls, 1)
		XCTAssertEqual(view.lastAvatarURL?.absoluteString, "https://example.com/avatar.jpg")
	}
}
