//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.02.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

	// MARK: - UI Elements

	private let avatarView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private let nameView: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 23, weight: .semibold)
		label.textColor = .white
		return label
	}()

	private let loginNameView: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .ypGrey
		return label
	}()

	private let descriptionView: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .white
		return label
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [nameView, loginNameView, descriptionView])
		stackView.axis = .vertical
		stackView.spacing = 8
		return stackView
	}()

	private lazy var logoutButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "exit"), for: .normal)
		button.tintColor = .ypRed
		let action = UIAction { [weak self] _ in
			self?.didTapLogoutButton()
		}
		button.addAction(action, for: .touchUpInside)
		return button
	}()

	// MARK: - Properties

	private var animations: Set<CALayer> = []
	private var avatarAnumation: CALayer?
	private let profileService = ProfileService.shared
	private var profileServiceObserver: NSObjectProtocol?
	private var profileImageServiceObserver: NSObjectProtocol?

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
		configureViews()

		[avatarView, nameView, loginNameView, descriptionView].forEach { view in
			view.layoutIfNeeded()
			let layer = Animations.loadingGradient()
			layer.cornerRadius = view.frame.height / 2
			layer.frame = view.bounds
			view.layer.addSublayer(layer)
			if view == avatarView {
				avatarAnumation = layer
			} else {
				animations.insert(layer)
			}
		}
		profileServiceObserver = NotificationCenter.default
			.addObserver(
				forName: ProfileService.didChangeNotification,
				object: nil,
				queue: .main
			) { [weak self] _ in
				guard let self = self else { return }
				self.configureViews()

			}
		profileImageServiceObserver = NotificationCenter.default
			.addObserver(
				forName: ProfileImageService.didChangeNotification,
				object: nil,
				queue: .main
			) { [weak self] _ in
				guard let self = self else { return }
				self.updateAvatar()
			}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureViews()
	}

	// MARK: - Setup Methods

	private func updateAvatar() {
		guard
			let profileImageURL = ProfileImageService.shared.avatarURL,
			let url = URL(string: profileImageURL)
		else { return }
		let processor = ResizingImageProcessor(referenceSize: CGSize(width: 70, height: 70), mode: .aspectFit)
		|> RoundCornerImageProcessor(cornerRadius: 35)
		avatarView.kf.setImage(
			with: url,
			//placeholder: UIImage(systemName: "person.crop.circle")?.withTintColor(.ypGrey),
			options: [.processor(processor)]) { [weak self] result in
				self?.avatarAnumation?.removeFromSuperlayer()
				self?.avatarAnumation = nil
			}
		avatarView.layer.masksToBounds = true
		avatarView.layer.cornerRadius = 35
	}

	private func setupView() {
		view.backgroundColor = .ypBlack
		[avatarView, stackView, logoutButton].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			avatarView.widthAnchor.constraint(equalToConstant: 70),
			avatarView.heightAnchor.constraint(equalToConstant: 70),
			avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.offset),
			avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),

			stackView.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
			stackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: UIConstants.smallOffset),

			logoutButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
			logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.offset),
			logoutButton.widthAnchor.constraint(equalToConstant: UIConstants.elementSize),
			logoutButton.heightAnchor.constraint(equalToConstant: UIConstants.elementSize),
		])
	}

	// MARK: - Configure Views

	private func configureViews() {
		nameView.text = profileService.profile?.name ?? " Dummy Dummy"
		loginNameView.text = profileService.profile?.loginName ?? " Dummy"
		descriptionView.text = profileService.profile?.bio ?? " Dummy description"
		if profileService.profile != nil {
			removeAnimations()
		}
		if avatarView.image != nil {
			avatarAnumation?.removeFromSuperlayer()
			avatarAnumation = nil
		}
	}

	private func removeAnimations() {
		animations.forEach { layer in
			layer.removeFromSuperlayer()
		}
		animations.removeAll()
	}

	private func switchToSplashScreenController() {
		// Получаем экземпляр `window` приложения
		guard let window = UIApplication.shared.windows.first else {
			assertionFailure("Invalid window configuration")
			return
		}

		let splashScreenController = SplashScreenViewController()

		// Установим в `rootViewController` полученный контроллер
		window.rootViewController = splashScreenController
	}

	// MARK: - Actions

	private func performExit() {
		ProfileLogoutService.shared.logout()
		dismiss(animated: true)
		switchToSplashScreenController()
	}

	private func didTapLogoutButton() {
		let alertController = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
			self?.performExit()
		}
		let noAction = UIAlertAction(title: "Нет", style: .default) { [weak self] _ in
			self?.dismiss(animated: true)
		}

		alertController.addAction(yesAction)
		alertController.addAction(noAction)
		
		present(alertController, animated: true)
	}
}
