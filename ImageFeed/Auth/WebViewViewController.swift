//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 15.02.2025.
//

import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController {
	enum WebViewConstants {
		static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
	}

	// MARK: - UI Elements

	private lazy var backButton = {
		let button = UIButton()
		button.setImage(UIConstants.imageBack, for: .normal)
		let action = UIAction { [weak self] _ in
			self?.dismiss(animated: true)
		}
		button.addAction(action, for: .touchUpInside)
		button.tintColor = .ypBlack
		return button
	}()

	private let progressView = {
		let progressBar = UIProgressView()
		progressBar.tintColor = .ypBlack
		return progressBar
	}()

	private let webView = {
		let webView = WKWebView()

		return webView
	}()

	// MARK: - Public Properties

	weak var delegate: WebViewViewControllerDelegate?

	// MARK: - Private Properties

	private var estimatedProgressObservation: NSKeyValueObservation?

	// MARK: - Overrides Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		[backButton, webView, progressView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}
		NSLayoutConstraint.activate([
			backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
			backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			backButton.widthAnchor.constraint(equalToConstant: UIConstants.elementSize),
			backButton.heightAnchor.constraint(equalToConstant: UIConstants.elementSize),
			
			progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
			progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			webView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

		])
		estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
			self?.updateProgress()
		}
		webView.navigationDelegate = self
		loadAuthView()
	}

	// MARK: - Private Methods

	private func backButtonTapped() {
		delegate?.webViewViewControllerDidCancel(self)
	}

	private func updateProgress() {
		progressView.progress = Float(webView.estimatedProgress)
		progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
	}

	private func loadAuthView() {
		guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
			return
		}

		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: Constants.accessKey),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "scope", value: Constants.accessScope)
		]

		guard let url = urlComponents.url else {
			return
		}

		let request = URLRequest(url: url)
		webView.load(request)
	}

	private func code(from navigationAction: WKNavigationAction) -> String? {
		if
			let url = navigationAction.request.url,
			let urlComponents = URLComponents(string: url.absoluteString),
			urlComponents.path == "/oauth/authorize/native",
			let items = urlComponents.queryItems,
			let codeItem = items.first(where: { $0.name == "code" })
		{
			return codeItem.value
		} else {
			return nil
		}
	}
}

extension WebViewViewController: WKNavigationDelegate {
	func webView(
		_ webView: WKWebView,
		decidePolicyFor navigationAction: WKNavigationAction,
		decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
	) {
		if let code = code(from: navigationAction) {
			decisionHandler(.cancel)
			delegate?.webViewViewController(self, didAuthenticateWithCode: code)
		} else {
			decisionHandler(.allow)
		}
	}
}
