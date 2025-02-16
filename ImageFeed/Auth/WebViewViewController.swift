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

	@IBOutlet weak var webView: WKWebView!
	weak var delegate: WebViewViewControllerDelegate?
	override func viewDidLoad() {
        super.viewDidLoad()

		webView.navigationDelegate = self
		loadAuthView()
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
		print(url)
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


