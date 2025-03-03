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
		let action = UIAction { _ in
			self.dismiss(animated: true)
		}
		button.addAction(action, for: .touchUpInside)
		button.tintColor = .white
		return button
	}()

	private lazy var shareButton = {
		let button = UIButton()
		button.setImage(UIConstants.imageShare, for: .normal)
		let action = UIAction { _ in
			self.shareButtonAction(button)
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

	var image: UIImage?

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
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 1.25

		guard let image else { return }
		imageView.image = image
		imageView.frame.size = image.size
		rescaleAndCenterImageInScrollView(image: image)
	}

	// MARK: - IB Actions

	@IBAction private func didTapBackButton() {
		dismiss(animated: true, completion: nil)
	}

	// MARK: - Private Methods
	
	private func shareButtonAction(_ sender: UIButton) {
		guard let image else { return }
		let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		present(activityVC, animated: true, completion: nil)
	}
	
	private func rescaleAndCenterImageInScrollView(image: UIImage) {
		let minZoomScale = scrollView.minimumZoomScale
		let maxZoomScale = scrollView.maximumZoomScale
		view.layoutIfNeeded()
		let visibleRectSize = scrollView.bounds.size
		let imageSize = image.size
		let hScale = (imageSize.width > 0) ? visibleRectSize.width / imageSize.width : 0
		let vScale = (imageSize.height > 0) ? visibleRectSize.height / imageSize.height : 0
		let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
		scrollView.setZoomScale(scale, animated: false)
		scrollView.layoutIfNeeded()
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
