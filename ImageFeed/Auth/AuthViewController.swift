//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 15.02.2025.
//

import UIKit

final class AuthViewController: UIViewController {

	// MARK: - Public Properties

	weak var delegate: AuthViewControllerDelegate?

	// MARK: - Private Properties

	private let showWebViewSegueIdentifier = "ShowWebView"
	private lazy var oauthService: OAuth2Service = OAuth2Service.shared

	// MARK: - Overrides Methods

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == showWebViewSegueIdentifier {
			guard
				let webViewViewController = segue.destination as? WebViewViewController
			else {
				assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
				return
			}
			webViewViewController.delegate = self
		} else {
			super.prepare(for: segue, sender: sender)
		}
	}
}

extension AuthViewController: WebViewViewControllerDelegate {
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
		oauthService.fetchOAuthToken(code) { [weak self] result in
			switch result {
				case .success(let token):
					guard let self else { return }
					self.delegate?.didAuthenticate(self, with: token)
				case .failure(let error):
					print(error.localizedDescription)
					vc.dismiss(animated: true)
					let alert = UIAlertController(
						title: "Ошибка",
						message: "Ошибка получения токена",
						preferredStyle: .alert
					)
					alert.addAction(UIAlertAction(title: "OK", style: .default))
					self?.present(alert, animated: true)
			}
		}
	}

	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		dismiss(animated: true)
	}
}
