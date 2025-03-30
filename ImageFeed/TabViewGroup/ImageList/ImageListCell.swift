//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 25.01.2025.
//

import UIKit

final class ImageListCell: UITableViewCell {

	// MARK: - UI Elements

	private var dateLabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .white
		return label
	}()

	private lazy var likeButton = {
		let button = UIButton()
		let originalImage = UIConstants.imageHeart
		let resizedImage = originalImage?.resized(to: CGSize(width: 21, height: 18))
		button.setImage(resizedImage?.withRenderingMode(.alwaysTemplate), for: .normal)

		button.imageView?.contentMode = .scaleAspectFit

		let action = UIAction { [weak self] _ in
			self?.likeButtonTapped()
		}
		button.addAction(action, for: .touchUpInside)
		return button
	}()

	private var cellImage = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()

	// MARK: - Public Properties

	weak var delegate: ImageListCellDelegate?

	// MARK: - Private Properties

	private var isLiked: Bool = false {
		didSet {
			likeButton.tintColor = isLiked ? .ypRed : .ypWhite50
		}
	}
	private var layers: Set<CALayer> = []

	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Overrided

	override func prepareForReuse() {
		super.prepareForReuse()

		cellImage.kf.cancelDownloadTask()
		layers.forEach { layer in
			layer.removeFromSuperlayer()
		}
		layers.removeAll()
	}

	// MARK: - Setup UI
	
	private func setupUI() {
		[cellImage, likeButton, dateLabel].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(view)
		}
		backgroundColor = .clear
		contentView.backgroundColor = .ypBlack
		selectionStyle = .none
		cellImage.layer.masksToBounds = true
		cellImage.layer.cornerRadius = UIConstants.cornerRadius
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.offset),
			cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.offset),
			cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.smallOffset / 2),
			cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.smallOffset / 2),

			dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: UIConstants.smallOffset),
			dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -UIConstants.smallOffset),

			likeButton.widthAnchor.constraint(equalToConstant: UIConstants.elementSize),
			likeButton.heightAnchor.constraint(equalToConstant: UIConstants.elementSize),
			likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
			likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor)
		])
	}

	// MARK: - IB Actions

	private func likeButtonTapped() {
		delegate?.didTapLikeButton(on: self)
	}

	// MARK: - Public Methods

	func config(with image: URL?, dateText: String, isLiked: Bool) {
		cellImage.contentMode = .center
		cellImage.backgroundColor = .ypWhite50

		let stubLayer = CALayer()
		if let stubImage = UIImage(named: "stub") {
			let stubSize = stubImage.size
			stubLayer.contents = stubImage.cgImage
			stubLayer.bounds = CGRect(origin: .zero, size: stubSize)
		}

		let gradientLayer = Animations.loadingGradient()
		gradientLayer.frame = bounds

		cellImage.layer.addSublayer(stubLayer)
		layers.insert(stubLayer)
		cellImage.layer.addSublayer(gradientLayer)
		layers.insert(gradientLayer)

		// Вызываем перед установкой позиции
		cellImage.layoutIfNeeded()
		stubLayer.position = CGPoint(x: cellImage.bounds.midX, y: bounds.midY)

		cellImage.layer.addSublayer(gradientLayer)
		cellImage.layer.addSublayer(stubLayer)
		cellImage.kf.indicatorType = .activity
		cellImage.kf.setImage(with: image) { [weak self] _ in
			self?.cellImage.contentMode = .scaleAspectFill
			self?.cellImage.kf.indicatorType = .none
			self?.backgroundColor = .clear
			self?.layers.forEach { layer in
				layer.removeFromSuperlayer()
			}
			self?.layers.removeAll()
		}
		dateLabel.text = dateText
		self.isLiked = isLiked
	}
}
