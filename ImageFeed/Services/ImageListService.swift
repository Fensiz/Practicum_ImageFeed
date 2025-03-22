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
			print(">>>>", photos.count)
			NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
		}
	}
	private var task: URLSessionTask?
	private var token = OAuth2TokenStorage.shared.token

	private var lastLoadedPage: Int?

	func fetchPhotosNextPage(completion: @escaping (ServiceError?) -> Void) {
		print("------>", lastLoadedPage)
		let urlRequest: URLRequest
		print("1")
		guard let token else {
			return
		}
		print("2")
		if let _ = task {
			return
		}
		lastLoadedPage = (lastLoadedPage ?? 0) + 1
		let result = RequestManager.createApiRequest(with: token, for: "photos", page: lastLoadedPage, perPage: 10)
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
}
