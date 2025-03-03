//
//  UIImage+Extensions.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 03.03.2025.
//

import UIKit

extension UIImage {
	func resized(to size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: size))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}
