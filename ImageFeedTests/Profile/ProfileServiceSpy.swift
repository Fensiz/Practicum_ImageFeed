//
//  ProfileServiceSpy.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 06.04.2025.
//

@testable import ImageFeed

class ProfileServiceSpy: ProfileServiceProtocol {
	private(set) var getProfileCalls = 0
	private(set) var profileValue: Profile?

	var profile: Profile? {
		get {
			getProfileCalls += 1
			return self.profileValue
		}
		set {
			self.profileValue = newValue
		}
	}
}
