//
//  ImageListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import Foundation

protocol ImageListPresenterProtocol {
	var photos: [Photo] { get }
	func viewDidLoad()
	func willDisplayCell(at indexPath: IndexPath)
	func didSelect(at indexPath: IndexPath)
	func didTapLike(at indexPath: IndexPath)
	func dateText(for photo: Photo) -> String
}
