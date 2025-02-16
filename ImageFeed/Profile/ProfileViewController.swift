//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 02.02.2025.
//

import UIKit

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
	private let avatarImageName: String = "avatar"
	private let userName: String = "Екатерина Новикова"
	private let userLogin: String = "@ekaterina_nov"
	private let userDescription: String = "Hello, world!"

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
		configureViews()
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
		avatarView.image = UIImage(named: avatarImageName) ?? UIImage(systemName: "person.circle")
		nameView.text = userName
		loginNameView.text = userLogin
		descriptionView.text = userDescription
	}

	// MARK: - Actions

	@objc private func didTapLogoutButton() {
		OAuth2TokenStorage.shared.token = nil
		print(OAuth2TokenStorage.shared.token)
	}
}
