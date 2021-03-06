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
@testable import BudgetKeeper

class AccountsViewModelUnitTest: XCTestCase {
  func testAccountsListEmpty() {
    let viewModel = AccountsViewModel()

    XCTAssertTrue(viewModel.accounts.isEmpty)
  }

  func testAddNewAccount() {
    let viewModel = AccountsViewModel()

    viewModel.create(account: "Debit card")

    XCTAssertEqual(viewModel.accounts.count, 1)
    XCTAssertEqual(viewModel.accounts.first?.name, "Debit card")
    XCTAssertEqual(viewModel.accounts.first?.balance, 0)
  }

  func testDeleteAccount() {
    let viewModel = AccountsViewModel()
    viewModel.create(account: "Salary")

    viewModel.delete(at: IndexSet(arrayLiteral: 0))

    XCTAssertTrue(viewModel.accounts.isEmpty)
  }

  func testUpdateBalance() {
    let viewModel = AccountsViewModel()
    viewModel.create(account: "Savings")

    viewModel.updateBalance(at: 0, by: -300)

    XCTAssertEqual(viewModel.accounts.first?.balance, -300)

    viewModel.updateBalance(at: 0, by: 450)

    XCTAssertEqual(viewModel.accounts.first?.balance, 150)
  }

  func testMultipleAccounts() {
    let viewModel = AccountsViewModel()

    viewModel.create(account: "Salary")
    viewModel.create(account: "Credit card")
    viewModel.create(account: "Savings")

    viewModel.delete(at: IndexSet(arrayLiteral: 1))
    viewModel.updateBalance(at: 1, by: 150)

    XCTAssertEqual(viewModel.accounts.count, 2)
    XCTAssertEqual(viewModel.accounts.map { $0.name }, ["Salary", "Savings"])
    XCTAssertEqual(viewModel.accounts[0].balance, 0)
    XCTAssertEqual(viewModel.accounts[1].balance, 150)
  }
}
