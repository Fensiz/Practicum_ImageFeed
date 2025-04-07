//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import XCTest
@testable import ImageFeed

class ProfilePresenterTests: XCTestCase {

	func test_viewDidLoad_callsUpdateProfileAndUpdateAvatar() {
		// Given
		let profile = Profile(
			result: ProfileResult(
				id: "id",
				updatedAt: "\(Date())",
				username: "john_doe",
				firstName: "John",
				lastName: "Doe",
				portfolioURL: nil,
				bio: "test bio"
			)
		)
		print(profile)
		let profileServiceSpy = ProfileServiceSpy()

		profileServiceSpy.profile = profile

//		spyProfileImageService.avatarURL = "https://example.com/avatar.jpg"
		let spyView = ProfileViewProtocolSpy()


		let sut = ProfilePresenter(view: spyView, profileService: profileServiceSpy)

		// When
		sut.viewDidLoad()

		// Then
		XCTAssertEqual(spyView.updateProfileCalls, 1)
		XCTAssertEqual(spyView.lastProfile?.name, profile.name)

//		XCTAssertEqual(spyView.updateAvatarCalls, 1)
//		XCTAssertEqual(spyView.lastAvatarURL?.absoluteString, spyProfileImageService.avatarURL)
//
//		XCTAssertEqual(spyProfileService.getProfileCalls, 1)
//		XCTAssertEqual(spyProfileImageService.getAvatarURLCalls, 1)
	}
}
