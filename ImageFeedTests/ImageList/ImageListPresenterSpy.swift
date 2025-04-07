//
//  ImageListPresenterSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

@testable import ImageFeed
import Foundation

final class ImageListPresenterSpy: ImageListPresenterProtocol {
	var viewDidLoadCalled = false
	var didTapLikeCalled = false
	var didSelectCalled = false
	var willDisplayCellCalled = false
	var tappedIndexPath: IndexPath?

	func viewDidLoad() {
		viewDidLoadCalled = true
	}

	func didTapLike(at indexPath: IndexPath) {
		didTapLikeCalled = true
		tappedIndexPath = indexPath
	}

	var photos: [Photo] = []
	func dateText(for photo: Photo) -> String { "Mock date" }
	func willDisplayCell(at indexPath: IndexPath) {
		willDisplayCellCalled = true
		tappedIndexPath = indexPath
	}
	func didSelect(at indexPath: IndexPath) {
		didSelectCalled = true
		tappedIndexPath = indexPath
	}
}
