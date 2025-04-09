//
//  ImageListViewProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import Foundation

protocol ImageListViewProtocol: AnyObject {
	func updateTable(in range: Range<Int>)
	func showError(_ error: Error)
	func reloadCell(at indexPath: IndexPath)
	func showFullImage(for photo: Photo)
	func showLoading()
	func hideLoading()
}
