//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewProtocol {

	private(set) var updateProfileCalls = 0
	private(set) var updateAvatarCalls = 0
	private(set) var showLogoutConfirmationCalls = 0
	private(set) var switchToSplashCalls = 0

	private(set) var lastProfile: Profile?
	private(set) var lastAvatarURL: URL?

	func updateProfile(with profile: Profile) {
		updateProfileCalls += 1
		lastProfile = profile
	}

	func updateAvatar(url: URL) {
		updateAvatarCalls += 1
		lastAvatarURL = url
	}

	func showLogoutConfirmation() {
		showLogoutConfirmationCalls += 1
	}

	func switchToSplash() {
		switchToSplashCalls += 1
	}
}
