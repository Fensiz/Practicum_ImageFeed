//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

protocol AuthViewControllerDelegate: AnyObject {
	func didAuthenticate(_ vc: AuthViewController, with token: String)
}
