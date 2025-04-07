//
//  Untitled.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

@testable import ImageFeed

final class ImageListServiceMock: ImageListServiceProtocol {
	
	var photos: [Photo] = []
	var fetchPhotosNextPageCalled = false
	var changeLikeCalled = false
	var fetchPhotosNextPageResult: Result<Void, ImageFeed.ServiceError> = .success(())
	private var likeCallback: ((Result<Void, ImageFeed.ServiceError>) -> Void)?
	private var fetchPhotosCompletion: ((ImageFeed.ServiceError?) -> Void)?

	func fetchPhotosNextPage(completion: @escaping (ImageFeed.ServiceError?) -> Void) {
		fetchPhotosNextPageCalled = true
		fetchPhotosCompletion = completion

		switch fetchPhotosNextPageResult {
		case .success:
			completion(nil)
		case .failure(let error):
			completion(error)
		}
	}

	func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, ImageFeed.ServiceError>) -> Void) {
		changeLikeCalled = true
		likeCallback = completion
	}

	func invokeLikeResult(_ result: Result<Void, ImageFeed.ServiceError>) {
		likeCallback?(result)
	}
}
