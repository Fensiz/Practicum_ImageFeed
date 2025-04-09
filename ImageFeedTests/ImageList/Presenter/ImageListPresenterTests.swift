//
//  ImageListPresenterTests.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

import XCTest
@testable import ImageFeed

final class ImageListPresenterTests: XCTestCase {
	private var presenter: ImageListPresenter!
	private var view: ImageListViewSpy!
	private var imageService: ImageListServiceMock!

	override func setUp() {
		super.setUp()
		view = ImageListViewSpy()
		imageService = ImageListServiceMock()
		presenter = ImageListPresenter(view: view, imageService: imageService)
	}

	func test_viewDidLoad_withError_shouldShowError() {
		// Given
		let expectedError = ServiceError.invalidURL
		imageService.fetchPhotosNextPageResult = .failure(expectedError)

		// When
		presenter.viewDidLoad()

		// Then
		XCTAssertTrue(view.showErrorCalled)
		guard let error = view.receivedError as? ServiceError else {
			XCTFail()
			return
		}
		switch error {
			case ServiceError.invalidURL:
				break
			default:
				XCTFail()
		}
	}

	func test_viewDidLoad_shouldCallFetchPhotosNextPage() {
		// when
		presenter.viewDidLoad()

		// then
		XCTAssertTrue(imageService.fetchPhotosNextPageCalled)
	}

	func test_didReceivePhotosUpdate_shouldCallUpdateTableIfCountChanged() {
		// given
		imageService.photos = [.mock, .mock]

		// when
		NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)

		// then
		XCTAssertEqual(view.updateTableCallCount, 1)
		XCTAssertEqual(view.updatedRange?.lowerBound, 0)
		XCTAssertEqual(view.updatedRange?.upperBound, 2)
	}

	func test_didTapLike_success() {
		// given
		imageService.photos = [.mock]
		NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)

		// when
		presenter.didTapLike(at: IndexPath(row: 0, section: 0))
		imageService.invokeLikeResult(.success(()))

		// then
		XCTAssertTrue(view.showLoadingCalled)
		XCTAssertTrue(view.hideLoadingCalled)
		XCTAssertTrue(view.reloadCellCalled)
	}

	func test_didTapLike_failure() {
		// given
		imageService.photos = [.mock]
		NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)

		// when
		presenter.didTapLike(at: IndexPath(row: 0, section: 0))
		imageService.invokeLikeResult(.failure(.invalidURL))

		// then
		XCTAssertTrue(view.showLoadingCalled)
		XCTAssertTrue(view.hideLoadingCalled)
		XCTAssertTrue(view.showErrorCalled)
	}

	func test_config_setsCorrectDataToCell() {
		//given
		imageService.photos = [.mock]
		NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
		let cell = ImageListCellSpy()

		//when
		presenter.config(cell: cell, at: IndexPath(row: 0, section: 0))

		//then
		XCTAssertTrue(cell.configCalled)
		XCTAssertEqual(cell.isLiked, false)
		XCTAssertEqual(cell.dateText, "1 January 1970")
	}

	func test_willDisplayCell_whenLastCell_shouldFetchNextPage() {
		// Given
		imageService.photos = [.mock, .mock]
		NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
		let indexPath = IndexPath(row: 1, section: 0)

		// When
		presenter.willDisplayCell(at: indexPath)

		// Then
		XCTAssertTrue(imageService.fetchPhotosNextPageCalled)
	}

	func test_dateText_shouldReturnFormattedDate() {
		// Given
		let date = Date(timeIntervalSince1970: 0)
		let photo = Photo(id: "1", size: .zero, createdAt: date, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false)

		// When
		let text = presenter.dateText(for: photo)

		// Then
		XCTAssertEqual(text, "1 January 1970")
	}

	func test_dateText_withNilDate_shouldReturnDash() {
		// Given
		let photo = Photo(id: "1", size: .zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false)

		// When
		let text = presenter.dateText(for: photo)

		// Then
		XCTAssertEqual(text, "-")
	}

	func test_didSelect_shouldCallShowFullImageWithCorrectPhoto() {
		// Given
		let photo = Photo.mock
		imageService.photos = [photo]
		NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)

		// When
		presenter.didSelect(at: IndexPath(row: 0, section: 0))

		// Then
		XCTAssertTrue(view.showFullImageCalled)
		XCTAssertEqual(view.shownPhoto?.id, photo.id)
	}
}
