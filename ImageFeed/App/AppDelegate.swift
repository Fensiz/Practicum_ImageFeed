//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 23.01.2025.
//

import UIKit
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		ProgressHUD.animationType = .activityIndicator
		ProgressHUD.colorBackground = .black
		ProgressHUD.colorAnimation = .lightGray

		return true
	}

	// MARK: UIScene Session Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
}

