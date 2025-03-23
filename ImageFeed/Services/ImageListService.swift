//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 20.03.2025.
//

import Foundation

final class ImageListService: ImageListServiceProtocol {
	
	static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
	private(set) var photos: [Photo] = [] {
		didSet {
			NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
		}
	}
	private var task: URLSessionTask?
	private var token = OAuth2TokenStorage.shared.token

	private var lastLoadedPage: Int?

	func fetchPhotosNextPage(completion: @escaping (ServiceError?) -> Void) {
		let urlRequest: URLRequest
		guard let token else {
			return
		}
		if let _ = task {
			return
		}
		lastLoadedPage = (lastLoadedPage ?? 0) + 1
		let result = RequestManager.getPhotos(with: token, page: lastLoadedPage, perPage: 10)
		switch result {
			case .success(let request):
				urlRequest = request
			case .failure(let error):
				ServiceError.log(error: error)
				completion(error)
				return
		}

		self.task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<[PhotoResult], ServiceError>) in
			switch result {
				case .success(let photosResult):
					DispatchQueue.main.async {
						self?.photos.append(contentsOf: photosResult.map {Photo($0)})
					}
					completion(nil)
				case .failure(let error):
					ServiceError.log(error: error)
					completion(error)
			}
			self?.task = nil
		}

		task?.resume()
	}

	func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, ServiceError>) -> Void) {

		let request = isLike ? RequestManager.unlikePhoto(token: token, id: photoId) : RequestManager.likePhoto(token: token, id: photoId)

		let urlRequest: URLRequest
		switch request {
			case .success(let request):
				urlRequest = request
			case .failure(let error):
				ServiceError.log(error: error)
				completion(.failure(error))
				return
		}
		URLSession.shared.data(for: urlRequest) { [weak self] (result: Result<Data, ServiceError>) in
			guard let self else { return }
			switch result {
				case .success(_):
					if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
						let photo = self.photos[index]
						let newPhoto = Photo(
							id: photo.id,
							size: photo.size,
							createdAt: photo.createdAt,
							welcomeDescription: photo.welcomeDescription,
							thumbImageURL: photo.thumbImageURL,
							largeImageURL: photo.largeImageURL,
							isLiked: !photo.isLiked
						)
						self.photos[index] = newPhoto
					}
					completion(.success(()))
				case .failure(let error):
					ServiceError.log(error: error)
					completion(.failure(error))
			}
		}.resume()
	}
}
