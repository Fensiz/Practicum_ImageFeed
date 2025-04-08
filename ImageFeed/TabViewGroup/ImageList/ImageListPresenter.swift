//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

import Foundation

final class ImageListPresenter {
	private weak var view: ImageListViewProtocol?
	private let imageService: ImageListServiceProtocol
	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()

	private(set) var photos: [Photo] = []

	init(view: ImageListViewProtocol, imageService: ImageListServiceProtocol = ImageListService()) {
		self.view = view
		self.imageService = imageService

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didReceivePhotosUpdate),
			name: ImageListService.didChangeNotification,
			object: nil
		)
	}

	@objc private func didReceivePhotosUpdate() {
		let oldCount = photos.count
		photos = imageService.photos
		if photos.count != oldCount {
			view?.updateTable(in: oldCount..<photos.count)
		}
	}
}

extension ImageListPresenter: ImageListPresenterProtocol {
	func viewDidLoad() {
		imageService.fetchPhotosNextPage { [weak self] error in
			if let error {
				self?.view?.showError(error)
			}
		}
	}

	func willDisplayCell(at indexPath: IndexPath) {
		guard ProcessInfo.processInfo.arguments.contains("UITEST") == false else { return }
		if indexPath.row == photos.count - 1 {
			imageService.fetchPhotosNextPage { _ in }
		}
	}

	func didSelect(at indexPath: IndexPath) {
		let photo = photos[indexPath.row]
		view?.showFullImage(for: photo)
	}

	func didTapLike(at indexPath: IndexPath) {
		let photo = photos[indexPath.row]
		view?.showLoading()
		imageService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
			guard let self else { return }
			switch result {
				case .failure(let error):
					self.view?.hideLoading()
					self.view?.showError(error)
				case .success:
					self.photos = self.imageService.photos
					self.view?.reloadCell(at: indexPath)
					self.view?.hideLoading()
			}
		}
	}

	func config(cell: ImageListCellProtocol, at indexPath: IndexPath) {
		let photo = photos[indexPath.row]
		let dateText = photo.createdAt.map { dateFormatter.string(from: $0) } ?? "-"
		cell.config(with: URL(string: photo.thumbImageURL), dateText: dateText, isLiked: photo.isLiked)
	}

	func dateText(for photo: Photo) -> String {
		guard let date = photo.createdAt else { return "-" }
		return dateFormatter.string(from: date)
	}
}
