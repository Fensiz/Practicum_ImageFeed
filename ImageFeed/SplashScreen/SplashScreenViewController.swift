//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import UIKit

class SplashScreenViewController: UIViewController {

	// MARK: - Private Properties

	private let profileService = ProfileService.shared
	private let tokenStorage = OAuth2TokenStorage.shared

	// MARK: - Overrides Methods

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		view.backgroundColor = .ypBlack
		navigateToNextScreen()
	}

	// MARK: - Private Methods

	private func navigateToNextScreen() {
		if let token = tokenStorage.token {
			fetchProfile(with: token)
		} else {
			let authVC = AuthViewController()
			authVC.delegate = self
			let navVC = UINavigationController(rootViewController: authVC)
			navVC.modalPresentationStyle = .fullScreen
			present(navVC, animated: true)
		}
	}
}

extension SplashScreenViewController: AuthViewControllerDelegate {
	func didAuthenticate(_ vc: AuthViewController, with token: String) {
		tokenStorage.token = token
		vc.dismiss(animated: true)
	}

	private func switchToTabBarController() {
		// Получаем экземпляр `window` приложения
		guard let window = UIApplication.shared.windows.first else {
			assertionFailure("Invalid window configuration")
			return
		}

		let tabBarVC = TabBarController()
		window.rootViewController = tabBarVC
	}

	private func fetchProfile(with token: String) {
		UIBlockingProgressHUD.show()
		profileService.fetchProfile(token) { [weak self] result in
			UIBlockingProgressHUD.dismiss()

			guard let self = self else { return }

			switch result {
				case .success(_):
					self.switchToTabBarController()

				case .failure(let error):
					ServiceError.log(error: error)

					let alert = UIAlertController(
						title: "Что-то пошло не так",
						message: "Не удалось получить профиль",
						preferredStyle: .alert
					)
					alert.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alert, animated: true)
					break
			}
		}
	}
}
