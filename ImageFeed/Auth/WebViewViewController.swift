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

	// MARK: - Public Properties

	weak var delegate: WebViewViewControllerDelegate?
	private var estimatedProgressObservation: NSKeyValueObservation?

	// MARK: - Private Properties

	@IBOutlet private weak var progressView: UIProgressView!
	@IBOutlet private weak var webView: WKWebView!
	

	// MARK: - Overrides Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
			self?.updateProgress()
		}
		webView.navigationDelegate = self
		loadAuthView()
	}

//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//		webView.addObserver(
//			self,
//			forKeyPath: #keyPath(WKWebView.estimatedProgress),
//			options: .new,
//			context: nil)
//		updateProgress()
//	}

//	override func viewWillDisappear(_ animated: Bool) {
//		super.viewWillDisappear(animated)
//		webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
//	}

//	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//		if keyPath == #keyPath(WKWebView.estimatedProgress) {
//			updateProgress()
//		} else {
//			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//		}
//	}

	// MARK: - IB Actions

	@IBAction private func backButtonTapped(_ sender: Any) {
		delegate?.webViewViewControllerDidCancel(self)
	}

	// MARK: - Private Methods

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
