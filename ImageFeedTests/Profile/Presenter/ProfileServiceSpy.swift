//
//  ProfileServiceSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

@testable import ImageFeed

final class ProfileServiceStub: ProfileServiceProtocol {
	var profile: ImageFeed.Profile?
}
