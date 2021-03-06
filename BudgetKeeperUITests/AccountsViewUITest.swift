/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest

class AccountsViewUITest: XCTestCase {
  let app = XCUIApplication()
  let currency = Locale.current.currencySymbol ?? "$"
  let separator = Locale.current.decimalSeparator ?? "."

  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launch()
  }

  func testAddAccount() {
    app.buttons["add_account"].tap()

    XCTAssertEqual(app.navigationBars.staticTexts.firstMatch.label, localizedString("New Account"))

    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("Savings")
    app.buttons["save"].tap()

    XCTAssertEqual(app.cells.count, 1)
    // since the cell content is wrapped into the navigation link, the element type is 'button'
    XCTAssertEqual(app.cells.buttons.firstMatch.label, "Savings\n\(currency)0\(separator)00")
  }

  func testDeleteAccount() {
    app.buttons["add_account"].tap()
    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("Savings")
    app.buttons["save"].tap()

    let cell = app.cells.firstMatch
    cell.swipeLeft()
    cell.buttons.firstMatch.tap()

    XCTAssertEqual(app.cells.count, 0)
  }

  func testUpdateBalance() {
    app.buttons["add_account"].tap()
    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("Savings")
    app.buttons["save"].tap()

    app.cells.firstMatch.tap()

    XCTAssertEqual(app.navigationBars.staticTexts.firstMatch.label, localizedString("Update Balance"))

    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("-120")
    app.buttons["save"].tap()

    XCTAssertEqual(app.cells.buttons.firstMatch.label, "Savings\n-\(currency)120\(separator)00")

    app.cells.firstMatch.tap()
    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("340")
    app.buttons["save"].tap()

    XCTAssertEqual(app.cells.buttons.firstMatch.label, "Savings\n\(currency)220\(separator)00")
  }

  func testMultipleAccounts() {
    app.buttons["add_account"].tap()
    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("Savings")
    app.buttons["save"].tap()

    app.buttons["add_account"].tap()
    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("Salary")
    app.buttons["save"].tap()

    app.cells.firstMatch.tap()
    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("7620")
    app.buttons["save"].tap()

    app.cells.element(boundBy: 1).tap()
    app.textFields.firstMatch.tap()
    app.textFields.firstMatch.typeText("5455")
    app.buttons["save"].tap()

    XCTAssertEqual(app.cells.count, 2)
    XCTAssertEqual(app.cells.buttons.firstMatch.label, "Savings\n\(currency)7620\(separator)00")
    XCTAssertEqual(app.cells.element(boundBy: 1).buttons.firstMatch.label, "Salary\n\(currency)5455\(separator)00")
  }
}

func localizedString(_ key: String) -> String {
  let result = NSLocalizedString(key, bundle: Bundle(for: AccountsViewUITest.self), comment: "")
  return result
}
