//
//  CertificationsTests.swift
//  TraktKitTests
//
//  Created by Maximilian Litteral on 8/10/17.
//  Copyright © 2017 Maximilian Litteral. All rights reserved.
//

import XCTest
import Foundation
@testable import TraktKit

final class CertificationsTests: TraktTestCase {
    func test_get_certifications() throws {
        try mock(.GET, "https://api.trakt.tv/certifications", result: .success(jsonData(named: "test_get_certifications")))

        let expectation = XCTestExpectation(description: "Get Certifications")
        traktManager.getCertifications { result in
            if case .success(let certifications) = result {
                XCTAssertEqual(certifications.us.count, 5)
                expectation.fulfill()
            }
        }
        let result = XCTWaiter().wait(for: [expectation], timeout: 1)
        
        switch result {
        case .timedOut:
            XCTFail("Something isn't working")
        default:
            break
        }
    }
}
