//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.02.2025.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {

	// MARK: - UI Elements

	private let avatarView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private let nameView: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 23, weight: .semibold)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let loginNameView: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .ypGrey
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let descriptionView: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [nameView, loginNameView, descriptionView])
		stackView.axis = .vertical
		stackView.spacing = 8
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var logoutButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "exit"), for: .normal)
		button.tintColor = .ypRed
		button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	// MARK: - Properties
	// в будущем зададим через init()
	private var avatarImageName: String = "avatar"
	private var userName: String = "Екатерина Новикова"
	private var userLogin: String = "@ekaterina_nov"
	private var userDescription: String = "Hello, world!"
	private let profileService = ProfileService.shared
	private var profileImageServiceObserver: NSObjectProtocol?

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
		configureViews()

		profileImageServiceObserver = NotificationCenter.default
			.addObserver(
				forName: ProfileImageService.didChangeNotification,
				object: nil,
				queue: .main
			) { [weak self] _ in
				guard let self = self else { return }
				self.updateAvatar()
			}
		updateAvatar()
	}
	private func updateAvatar() {
		guard
			let profileImageURL = ProfileImageService.shared.avatarURL,
			let url = URL(string: profileImageURL)
		else { return }
		let processor = ResizingImageProcessor(referenceSize: CGSize(width: 70, height: 70), mode: .aspectFit)
			|> RoundCornerImageProcessor(cornerRadius: 35)
		avatarView.kf.setImage(
			with: url,
			placeholder: UIImage(systemName: "person.crop.circle")?.withTintColor(.ypGrey),
			options: [.processor(processor)]
		)


	}

	// MARK: - Setup Methods

	private func setupView() {
		view.backgroundColor = .ypBlack
		view.addSubview(avatarView)
		view.addSubview(stackView)
		view.addSubview(logoutButton)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// Аватар
			avatarView.widthAnchor.constraint(equalToConstant: 70),
			avatarView.heightAnchor.constraint(equalToConstant: 70),
			avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),

			// StackView (имя, логин, описание)
			stackView.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
			stackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),

			// Кнопка выхода
			logoutButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
			logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			logoutButton.widthAnchor.constraint(equalToConstant: 44),
			logoutButton.heightAnchor.constraint(equalToConstant: 44)
		])
	}

	// MARK: - Configure Views

	private func configureViews() {
		avatarView.image = UIImage(named: avatarImageName)
		nameView.text = profileService.profile?.name
		loginNameView.text = profileService.profile?.loginName
		descriptionView.text = profileService.profile?.bio
	}

	private func switchToSplashScreenController() {
		// Получаем экземпляр `window` приложения
		guard let window = UIApplication.shared.windows.first else {
			assertionFailure("Invalid window configuration")
			return
		}

		// Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
		let splashScreenController = UIStoryboard(name: "Main", bundle: .main)
			.instantiateViewController(withIdentifier: "SplashScreenViewController")

		// Установим в `rootViewController` полученный контроллер
		window.rootViewController = splashScreenController
	}

	// MARK: - Actions

	@objc private func didTapLogoutButton() {
		KeychainWrapper.standard.removeObject(forKey: "Auth token")
		OAuth2TokenStorage.shared.token = nil
		dismiss(animated: true)
		switchToSplashScreenController()
	}
}
