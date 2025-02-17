//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import UIKit

class SplashScreenViewController: UIViewController {

	// MARK: - Private Properties

	private let authenticationScreenSegueId = "showAuthenticationScreenSegue"
	private lazy var storageService = OAuth2TokenStorage.shared

	// MARK: - Overrides Methods

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigateToNextScreen()
	}

	// MARK: - Private Methods

	private func navigateToNextScreen() {
		if let _ = storageService.token {
			switchToTabBarController()
		} else {
			performSegue(withIdentifier: authenticationScreenSegueId, sender: nil)
		}
	}
}

extension SplashScreenViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == authenticationScreenSegueId {
			guard
				let navigationController = segue.destination as? UINavigationController,
				let viewController = navigationController.viewControllers[0] as? AuthViewController
			else {
				assertionFailure("Failed to prepare for \(authenticationScreenSegueId)")
				return
			}
			viewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
}

extension SplashScreenViewController: AuthViewControllerDelegate {
	func didAuthenticate(_ vc: AuthViewController, with token: String) {
		storageService.token = token
		dismiss(animated: true)
		switchToTabBarController()
	}

	private func switchToTabBarController() {
		// Получаем экземпляр `window` приложения
		guard let window = UIApplication.shared.windows.first else {
			assertionFailure("Invalid window configuration")
			return
		}

		// Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
		let tabBarController = UIStoryboard(name: "Main", bundle: .main)
			.instantiateViewController(withIdentifier: "TabBarViewController")

		// Установим в `rootViewController` полученный контроллер
		window.rootViewController = tabBarController
	}
}
