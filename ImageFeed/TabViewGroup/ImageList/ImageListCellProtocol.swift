//
//  ImageListCellProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

import Foundation

protocol ImageListCellProtocol: AnyObject {
	func config(with url: URL?, dateText: String, isLiked: Bool)
}
