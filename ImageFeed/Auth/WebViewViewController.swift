//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 15.02.2025.
//

import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController {

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
	var presenter: WebViewPresenterProtocol?

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
		setupConstraints()
		estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
			guard let self else { return }
			self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
		}
		webView.navigationDelegate = self
		let authHelper = AuthHelper()
		presenter = WebViewPresenter(authHelper: authHelper)
		presenter?.view = self
		presenter?.viewDidLoad()
	}

	// MARK: - Private Methods

	private func backButtonTapped() {
		delegate?.webViewViewControllerDidCancel(self)
	}

	private func code(from navigationAction: WKNavigationAction) -> String? {
		if let url = navigationAction.request.url {
			return presenter?.code(from: url)
		}
		return nil
	}

	private func setupConstraints() {
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

extension WebViewViewController: WebViewViewControllerProtocol {
	func setProgressValue(_ newValue: Float) {
		progressView.progress = newValue
	}
	
	func setProgressHidden(_ isHidden: Bool) {
		progressView.isHidden = isHidden
	}

	func load(request: URLRequest) {
		webView.load(request)
	}
}
