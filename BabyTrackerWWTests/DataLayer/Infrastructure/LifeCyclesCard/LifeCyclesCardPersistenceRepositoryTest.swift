//
//  LifeCyclesCardPersistenceRepositoryTest.swift
//  BabyTrackerWWTests
//
//  Created by Max on 25.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import XCTest
@testable import BabyTrackerWW


class LifeCyclesCardPersistenceRepositoryTest: XCTestCase {
    
    func test_synchronizeWith_failedWakeRepo_andCancelChanges() throws {
        //Given
        let error = PersistenceRepositoryErrorMock.error
        let dreamRepo = DreamPersistentRepositoryMock(dreamResult: (.success([Dream]())), emprtyResult: (.success(())))
        let wakeRepo = WakePersistentRepositoryMock(dreamResult: (.success([Wake]())), emprtyResult: (.failure(error)))
        let lcRepo = LifeCyclesCardPersistentRepositoryImpl(dreamRepository: dreamRepo, wakeRepository: wakeRepo)
        let newValue = [LifeCycle]()
        let oldValue = [LifeCycle]()
        let date = Date()
        let expectationCallback = expectation(description: #function)
        //When
        lcRepo.synchronize(newValue: newValue, oldValue: oldValue, date: date) { result in
            //Then
                // Ожидаю:
                    // - отработку отмены синхронизации и принт в чат: "::: Сhanges canceled after failed synchronization" (пока не делал реализацию хендлинга результата отмены синхронизации. Не знаю нужна ли она)
                    // - возврат ошибки в коллбек
            switch result {
            case .success(_): XCTFail("Failed, expected result == failure")
            case let .failure(error): XCTAssertTrue(error is PersistenceRepositoryErrorMock)
            }
            expectationCallback.fulfill()
        }
        wait(for: [expectationCallback], timeout: 0.5)
    }
    
}







