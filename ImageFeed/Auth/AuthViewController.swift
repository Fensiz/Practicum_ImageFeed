//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 15.02.2025.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {

	// MARK: - UI Elements

	private lazy var loginButton = {
		let button = UIButton()
		button.setTitle("Войти", for: .normal)
		button.backgroundColor = .white
		button.setTitleColor(.ypBlack, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
		button.layer.cornerRadius = UIConstants.cornerRadius
		let action = UIAction { [weak self] _ in
			self?.loginButtonTapped()
		}
		button.accessibilityIdentifier = "LoginButton"
		button.addAction(action, for: .touchUpInside)
		return button
	}()

	private let logoImageView = {
		let imageView = UIImageView(image: UIConstants.imageUnsplashLogo)
		return imageView
	}()

	// MARK: - Public Properties

	weak var delegate: AuthViewControllerDelegate?

	// MARK: - Private Properties

	private let showWebViewSegueIdentifier = "ShowWebView"
	private lazy var oauthService: OAuth2Service = OAuth2Service.shared

	// MARK: - Overrides Methods

	override func viewDidLoad() {
		super.viewDidLoad()

		view.accessibilityIdentifier = "AuthViewController"
		view.backgroundColor = .ypBlack
		[loginButton, logoImageView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}

		NSLayoutConstraint.activate([
			logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

			loginButton.heightAnchor.constraint(equalToConstant: 48),
			loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.offset),
			loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.offset),
			loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
		])
	}

	// MARK: - Private Methods

	private func loginButtonTapped() {
		let webViewVC = WebViewViewController()
		webViewVC.delegate = self
		let authHelper = AuthHelper()
		webViewVC.presenter = WebViewPresenter(authHelper: authHelper)
		webViewVC.presenter?.view = webViewVC
		webViewVC.modalPresentationStyle = .fullScreen
		self.present(webViewVC, animated: true)
	}
}

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
					ServiceError.log(error: error)
					
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
