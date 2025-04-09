//
//  ImageListViewSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 07.04.2025.
//

@testable import ImageFeed
import Foundation

final class ImageListViewSpy: ImageListViewProtocol {
	var updateTableCallCount = 0
	var updatedRange: Range<Int>?

	var showLoadingCalled = false
	var hideLoadingCalled = false
	var reloadCellCalled = false
	var showErrorCalled = false
	var showFullImageCalled = false
	var receivedError: Error?
	var shownPhoto: Photo?

	func updateTable(in range: Range<Int>) {
		updateTableCallCount += 1
		updatedRange = range
	}

	func showError(_ error: Error) {
		showErrorCalled = true
		receivedError = error
	}

	func showLoading() { showLoadingCalled = true }
	func hideLoading() { hideLoadingCalled = true }
	func reloadCell(at indexPath: IndexPath) { reloadCellCalled = true }
	
	func showFullImage(for photo: Photo) {
		showFullImageCalled = true
		shownPhoto = photo
	}
}
