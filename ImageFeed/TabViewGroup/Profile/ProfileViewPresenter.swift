//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import Foundation

final class ProfilePresenter {
	private weak var view: ProfileViewProtocol?
	private let profileService: ProfileService
	private let profileImageService: ProfileImageService
	private var profileImageObserver: NSObjectProtocol?

	init(view: ProfileViewProtocol,
		 profileService: ProfileService = .shared,
		 profileImageService: ProfileImageService = .shared) {
		self.view = view
		self.profileService = profileService
		self.profileImageService = profileImageService
		setupObserver()
	}

	private func setupObserver() {
		profileImageObserver = NotificationCenter.default.addObserver(
			forName: ProfileImageService.didChangeNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			self?.updateAvatar()
		}
	}

	private func updateAvatar() {
		guard let urlString = profileImageService.avatarURL,
			  let url = URL(string: urlString) else { return }
		view?.updateAvatar(url: url)
	}
}

extension ProfilePresenter: ProfilePresenterProtocol {
	func viewDidLoad() {
		if let profile = profileService.profile {
			view?.updateProfile(with: profile)
		}
		updateAvatar()
	}

	func didTapLogout() {
		view?.showLogoutConfirmation()
	}

	func confirmLogout() {
		ProfileLogoutService.shared.logout()
		view?.switchToSplash()
	}
}
