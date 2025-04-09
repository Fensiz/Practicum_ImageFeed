//
//  Untitled.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
	func updateProfile(with profile: Profile)
	func updateAvatar(url: URL)
	func showLogoutConfirmation()
	func switchToSplash()
}
