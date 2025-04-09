//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.02.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {

	// MARK: - UI Elements

	private lazy var scrollView = {
		let scrollView = UIScrollView()
		scrollView.isScrollEnabled = true
		scrollView.contentMode = .scaleToFill
		scrollView.delegate = self
		scrollView.addSubview(imageView)
		return scrollView
	}()

	private lazy var backButton = {
		let button = UIButton()
		button.setImage(UIConstants.imageBack, for: .normal)
		let action = UIAction { [weak self] _ in
			self?.dismiss(animated: true)
		}
		button.addAction(action, for: .touchUpInside)
		button.tintColor = .white
		button.accessibilityIdentifier = AccessibilityIds.backButton
		return button
	}()

	private lazy var shareButton = {
		let button = UIButton()
		button.setImage(UIConstants.imageShare, for: .normal)
		let action = UIAction { [weak self] _ in
			self?.shareButtonAction(button)
		}
		button.addAction(action, for: .touchUpInside)
		return button
	}()

	private let imageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	// MARK: - Public Properties

	var image: Photo?

	// MARK: - Overrides Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .ypBlack
		[scrollView, backButton, shareButton].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}

		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

			backButton.widthAnchor.constraint(equalToConstant: UIConstants.elementSize),
			backButton.heightAnchor.constraint(equalToConstant: UIConstants.elementSize),
			backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.smallOffset),
			backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.smallOffset),

			shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.offset),
			shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

		])
		setImage()
	}

	// MARK: - Private Methods

	private func setImage() {
		guard let image else { return }
		UIBlockingProgressHUD.show()
		let stub = UIImage(named: "stub") ?? UIImage()

		imageView.image = stub //задаем, чтобы был правильный фрейм при расчете масштабирования
		rescaleAndCenterImageInScrollView(image: stub, scale: 1)

		imageView.kf.setImage(
			with: URL(string: image.largeImageURL),
			placeholder: stub,
			completionHandler: { [weak self] result in
			UIBlockingProgressHUD.dismiss()
			guard let self else { return }
			DispatchQueue.main.async {
				switch result {
					case .success(let value):
						self.imageView.contentMode = .scaleAspectFit
						self.imageView.frame.size = image.size
						self.rescaleAndCenterImageInScrollView(image: value.image)
					case .failure(_):
						self.showError()
				}
			}
		})
	}

	private func showError() {
		let alert = UIAlertController(title: "Что-то пошло не так...", message: "Попробовать ещё раз?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Не надо", style: .default))
		alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
			self?.setImage()
		})

		self.present(alert, animated: true)
	}

	private func shareButtonAction(_ sender: UIButton) {
		guard let image = imageView.image else { return }
		let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		present(activityVC, animated: true, completion: nil)
	}
	
	private func rescaleAndCenterImageInScrollView(image: UIImage, scale: CGFloat? = nil) {
		view.layoutIfNeeded()

		let scrollViewSize = scrollView.bounds.size
		let imageSize = image.size

		let widthScale = scrollViewSize.width / imageSize.width
		let heightScale = scrollViewSize.height / imageSize.height
		var minScale = min(widthScale, heightScale)

		if let scale {
			minScale = scale
		}

		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = 3.0
		scrollView.setZoomScale(minScale, animated: false)

		updateContentInsets()
	}

	private func updateContentInsets() {
		let imageViewSize = imageView.frame.size
		let scrollViewSize = scrollView.bounds.size

		let horizontalInset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
		let verticalInset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)

		scrollView.contentInset = UIEdgeInsets(
			top: verticalInset,
			left: horizontalInset,
			bottom: verticalInset,
			right: horizontalInset
		)
	}
}

extension SingleImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateContentInsets()
	}
}
