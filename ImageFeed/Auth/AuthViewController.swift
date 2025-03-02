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
import ProgressHUD
extension AuthViewController: WebViewViewControllerDelegate {
	func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
		vc.dismiss(animated: true)

		UIBlockingProgressHUD.show()

		oauthService.fetchOAuthToken(code) { [weak self] result in
			UIBlockingProgressHUD.dismiss()
			guard let self else { return }
			switch result {
				case .success(let token):
					self.delegate?.didAuthenticate(self, with: token)
				case .failure(let error):
					print(error.localizedDescription)

					let alert = UIAlertController(
						title: "Что-то пошло не так",
						message: "Не удалось войти в систему",
						preferredStyle: .alert
					)
					alert.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alert, animated: true)
			}
		}
	}

	func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
		vc.dismiss(animated: true)
	}
}
