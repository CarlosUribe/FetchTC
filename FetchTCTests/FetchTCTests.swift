//
//  FetchTCTests.swift
//  FetchTCTests
//
//  Created by Carlos Uribe on 10/08/23.
//

import XCTest
@testable import FetchTC

final class FetchTCTests: XCTestCase {

    var requestMain: MainModel!
    var requestDetail: DetailModel!
    var failureRequestDetail: DetailModel!
    let idMeal = "53049"
    let mealName = "Apam balik"

    override func setUp() {
        requestMain = MainModel()
        requestDetail = DetailModel(idMeal)
        failureRequestDetail = DetailModel("")
    }

    func testGetDataForMainSecreenSuccess() {
        let expectation = expectation(description: "Request data for main screen should be successful")
        requestMain.getDataForMainScreen { result in
            switch result {
            case .success(let meal):
                let elemet = meal.first
                XCTAssertTrue(elemet?.idMeal == self.idMeal)
                XCTAssertTrue(elemet?.strMeal == self.mealName)
            case .failure(let error):
                XCTFail("Backend should respond correctly, failed with \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

    }

    func testGetDetailForDetailScreenSuccess() {
        let expectation = expectation(description: "Request data for detail screen should be successful")
        requestDetail.getDataForDetailScreen { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data["idMeal"] == self.idMeal)
                XCTAssertTrue(data["strMeal"] == self.mealName)
            case .failure(let error):
                XCTFail("Backend should respond correctly, failed with \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testGetDetailForDetailScreenFailure() {
        let expectation = expectation(description: "Request data for detail screen should fail without correct meal id")
        failureRequestDetail.getDataForDetailScreen { result in
            switch result {
            case .success(_):
                XCTFail("Backend should fail")
            case .failure(let error):
                XCTAssertTrue(error == BackendError.DataError)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
