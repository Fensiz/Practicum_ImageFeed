//
//  LikeButton.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.03.2025.
//

import UIKit

final class LikeButton: UIButton {
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let largerArea = self.bounds.insetBy(dx: -7, dy: -13)
		return largerArea.contains(point)
	}
}
