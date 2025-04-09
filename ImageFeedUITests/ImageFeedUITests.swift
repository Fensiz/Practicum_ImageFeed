//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Симонов Иван Дмитриевич on 05.04.2025.
//

import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
	private let app = XCUIApplication()

	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launchArguments = [
			"UITEST"
		]
		app.launch()
	}

	func testAuth() throws {
		app.buttons[AccessibilityIds.loginButton].tap()
		let webView = app.webViews[AccessibilityIds.webWiew]
		guard webView.waitForExistence(timeout: 5) == true else {
			XCTFail()
			return
		}
		let loginTextField = webView.descendants(matching: .textField).element
		XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
		loginTextField.tap()
		loginTextField.swipeUp()
		loginTextField.typeText("simonov.ivan@inbox.ru")
		let passwordTextField = webView.descendants(matching: .secureTextField).element
		XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
		passwordTextField.tap()
		sleep(5)
		passwordTextField.typeText("<passwd>")
		sleep(2)
		webView.buttons["Login"].tap()

		let tablesQuery = app.tables
		let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
		XCTAssertTrue(cell.waitForExistence(timeout: 10))
	}

	func testFeed() throws {
		let table = app.tables[AccessibilityIds.imageListTableView]
		XCTAssertTrue(table.waitForExistence(timeout: 5), "Таблица не появилась на экране")

		let cell = table.cells.element(boundBy: 0)
		XCTAssertTrue(cell.waitForExistence(timeout: 5), "Первая ячейка не загрузилась")

		sleep(12)

		cell.swipeUp()

		sleep(3)

		// на симуляторе не работает, тк размеры ячейки и кнопки равны 0, не знаю почему

		table.cells.element(boundBy: 1).buttons[AccessibilityIds.likeButton].tap()

		sleep(2)

		table.cells.element(boundBy: 1).buttons[AccessibilityIds.likeButton].tap()

		sleep(2)

		let likeCell = table.cells.element(boundBy: 1)
		likeCell.tap()

		let bigImage = app.scrollViews.images.element(boundBy: 0)
		bigImage.pinch(withScale: 3, velocity: 1)
		sleep(1)
		bigImage.pinch(withScale: 0.5, velocity: -1)

		let backButton = app.buttons[AccessibilityIds.backButton]
		backButton.tap()

		sleep(1)

		table.swipeUp()
	}

	func testProfile() throws {
		sleep(3)
		app.tabBars.buttons.element(boundBy: 1).tap()

		XCTAssertTrue(app.staticTexts["Ivan Simonov"].exists)
		XCTAssertTrue(app.staticTexts["@fensiz"].exists)

		app.buttons[AccessibilityIds.logoutButton].tap()

		app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

		XCTAssertTrue(app.otherElements[AccessibilityIds.authViewController].waitForExistence(timeout: 5))
	}
}
