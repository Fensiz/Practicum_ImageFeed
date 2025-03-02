//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import UIKit
import SwiftKeychainWrapper

class SplashScreenViewController: UIViewController {

	// MARK: - Private Properties

	private let authenticationScreenSegueId = "showAuthenticationScreenSegue"
	private let profileService = ProfileService.shared

	// MARK: - Overrides Methods

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigateToNextScreen()
	}

	// MARK: - Private Methods

	private func navigateToNextScreen() {
		if let token = KeychainWrapper.standard.string(forKey: "Auth token") {
			fetchProfile(with: token)
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
		let isSuccess = KeychainWrapper.standard.set(token, forKey: "Auth token")
		guard isSuccess else {
			fatalError("Не удалось записать токен в Keychain")
		}
//		storageService.token = token
		vc.dismiss(animated: true)
		fetchProfile(with: token)
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

	private func fetchProfile(with token: String) {
		UIBlockingProgressHUD.show()
		profileService.fetchProfile(token) { [weak self] result in
			UIBlockingProgressHUD.dismiss()

			guard let self = self else { return }

			switch result {
				case .success(let token):
					print("TOKEN>>>>>>", token)
					self.switchToTabBarController()


				case .failure(let error):
					// TODO [Sprint 11] Покажите ошибку получения профиля
					print("ERROR>>>>>", error.localizedDescription)
					break
			}
		}
	}
}
