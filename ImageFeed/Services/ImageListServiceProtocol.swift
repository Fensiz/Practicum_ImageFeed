//
//  ImageListServiceProtocol.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 20.03.2025.
//

protocol ImageListServiceProtocol {
	var photos: [Photo] { get }
	func fetchPhotosNextPage(completion: @escaping (ServiceError?) -> Void)
}
