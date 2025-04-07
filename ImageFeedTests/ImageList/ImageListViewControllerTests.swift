//
//  ImageListViewControllerTests.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import XCTest
@testable import ImageFeed

final class ImageListViewControllerTests: XCTestCase {
	func test_viewDidLoad_callsPresenterViewDidLoad() {
		// Given
		let presenter = ImageListPresenterSpy()
		let sut = ImageListViewController()
		sut.presenter = presenter

		// When
		_ = sut.view

		// Then
		XCTAssertTrue(presenter.viewDidLoadCalled)
	}

	func test_tableView_didTapLike_callsPresenterDidTapLike() {
		// Given
		let presenter = ImageListPresenterSpy()
		presenter.photos = [Photo.mock]
		let sut = ImageListViewController()
		sut.presenter = presenter
		_ = sut.view

		let tableView = sut.view.subviews.first(where: { $0 is UITableView }) as! UITableView

		let indexPath = IndexPath(row: 0, section: 0)
		let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as! ImageListCell
		cell.delegate = sut

		// When
		sut.didTapLikeButton(on: cell)

		// Then
		XCTAssertTrue(presenter.didTapLikeCalled)
		XCTAssertEqual(presenter.tappedIndexPath, indexPath)
	}

	func test_tableView_didSelectRowAt_callsDidSelect() {
		// Given
		let presenter = ImageListPresenterSpy()
		presenter.photos = [Photo.mock]
		let sut = ImageListViewController()
		sut.presenter = presenter
		_ = sut.view

		let tableView = sut.view.subviews.first(where: { $0 is UITableView }) as! UITableView

		let indexPath = IndexPath(row: 0, section: 0)

		// When
		tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)

		// Then
		XCTAssertTrue(presenter.didSelectCalled)
		XCTAssertEqual(presenter.tappedIndexPath, indexPath)
	}

	func test_tableView_willDisplay_callswillDisplayCell() {
		// Given
		let presenter = ImageListPresenterSpy()
		presenter.photos = [Photo.mock]
		let sut = ImageListViewController()
		sut.presenter = presenter
		_ = sut.view

		let tableView = sut.view.subviews.first(where: { $0 is UITableView }) as! UITableView

		let indexPath = IndexPath(row: 0, section: 0)


		// When
		tableView.delegate?.tableView?(tableView, willDisplay: UITableViewCell(), forRowAt: indexPath)

		// Then
		XCTAssertTrue(presenter.willDisplayCellCalled)
		XCTAssertEqual(presenter.tappedIndexPath, indexPath)
	}
}
