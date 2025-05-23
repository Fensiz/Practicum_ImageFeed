//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 01.03.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
	private init() {}
	private static var window: UIWindow? {
		UIApplication.shared.windows.first
	}

	static func show() {
		window?.isUserInteractionEnabled = false
		ProgressHUD.animate()
	}

	static func dismiss() {
		window?.isUserInteractionEnabled = true
		ProgressHUD.dismiss()
	} 
}
