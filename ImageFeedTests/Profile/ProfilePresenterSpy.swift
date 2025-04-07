//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {

	var didTapLogoutCalled = false
	var confirmLogoutCalled = false

	func viewDidLoad() {

	}

	func didTapLogout() {
		didTapLogoutCalled = true
	}

	func confirmLogout() {
		confirmLogoutCalled = true
	}
}
