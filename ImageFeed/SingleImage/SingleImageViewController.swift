//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.02.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {

	// MARK: - IB Outlets

	@IBOutlet weak private var scrollView: UIScrollView!
	@IBOutlet weak private var imageView: UIImageView!

	// MARK: - Public Properties

	var image: UIImage?

	// MARK: - Overrides Methods

	override func viewDidLoad() {
		super.viewDidLoad()
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
	
	@IBAction private func shareButtonAction(_ sender: UIButton) {
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
