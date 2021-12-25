//
//  NetworkClientTest.swift
//  BabyTrackerWWTests
//
//  Created by Max on 25.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import XCTest
@testable import BabyTrackerWW


class NetworkClientTest: XCTestCase {
    
    func test_networkExecuteWith_200___299_response() throws {
        //Given
        let url = ApiURL(scheme: .http, host: "jsonplaceholder.typicode.com", path: "/posts/1/comments", endPoint: nil)
        let request = APIRequest(url: url, method: .get, header: ["Content-type" : "application/json"], body: nil)
        let config = APISession.default
        let networkClient = ApiClientImpl(requestConfig: request, sessionConfig: config)
        let expectationCallback = expectation(description: #function)
        //When
        networkClient.execute { result in
            // Then
                // Ожидаю:
                    // - корректную сборку реквеста из составляющих
                    // - success result
            guard let _ = try? result.get() else {
                XCTFail("Failed, error");
                return
            }
            expectationCallback.fulfill()
        }
        wait(for: [expectationCallback], timeout: 1)
    }
    
}
