//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
	override func awakeFromNib() {
		super.awakeFromNib()
		let storyboard = UIStoryboard(name: "Main", bundle: .main)
		let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
		let profileViewController = ProfileViewController()
		profileViewController.tabBarItem = UITabBarItem(
			title: "",
			image: UIImage(named: "profile.active"),
			selectedImage: nil
		)
		self.viewControllers = [imagesListViewController, profileViewController]
	}
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		let imagesListViewController = ImageListViewController()
//		imagesListViewController.tabBarItem = UITabBarItem(
//			title: "",
//			image: UIImage(named: "stack.active"),
//			selectedImage: nil
//		)
//		let profileViewController = ProfileViewController()
//		profileViewController.tabBarItem = UITabBarItem(
//			title: "",
//			image: UIImage(named: "profile.active"),
//			selectedImage: nil
//		)
//		self.viewControllers = [imagesListViewController, profileViewController]
//	}
}
