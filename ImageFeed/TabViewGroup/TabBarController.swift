//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .ypBlack
		view.tintColor = .white

//		tabBarController?.tabBar.barTintColor = .ypBlack
		let appearance = UITabBarAppearance()
		appearance.configureWithDefaultBackground()
		appearance.backgroundColor = .ypBlack
		tabBar.standardAppearance = appearance

		let imagesListViewController = ImageListViewController()
		imagesListViewController.tabBarItem = UITabBarItem(
			title: "",
			image: UIConstants.imageStack,
			selectedImage: nil
		)
		let profileViewController = ProfileViewController()
		profileViewController.tabBarItem = UITabBarItem(
			title: "",
			image: UIConstants.imageProfile,
			selectedImage: nil
		)
		self.viewControllers = [imagesListViewController, profileViewController]
	}
}
