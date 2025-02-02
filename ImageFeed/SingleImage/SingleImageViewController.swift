//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.02.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
	var image: UIImage? {
		didSet {
			guard isViewLoaded else { return }
			imageView.image = image
		}
	}

	@IBOutlet private var imageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = image
	}
} 
