//
//  NetworkRepository+DTOMapperTest.swift
//  BabyTrackerWWTests
//
//  Created by Max on 24.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import XCTest
@testable import BabyTrackerWW


class NetworkRepositoryDTOMapperTest: XCTestCase {
    
    
    func test_networkRequestWith_lifecyclesResult() throws {
        //Given
        let data = lifecyclesResultJson
        let network = NetworkRepositoryDTOMapper(client: ApiCLientStub(result: .success(data)))
        let expectedResult: [LifeCycle] = [
            Dream(id: UUID(uuidString: "4B38EFC7-CD93-4D16-9137-0399AD15E6C0")!, index: 0, putDown: .brestFeeding, fallAsleep: .crying, note: "b"),
            Dream(id: UUID(uuidString: "7BB1077F-5C22-4259-838D-DCF49E296989")!, index: 1, putDown: .brestFeeding, fallAsleep: .crying, note: "c"),
            Wake(id: UUID(uuidString: "37F1CFBB-C4A6-4F36-924F-884D859F6F2C")!, index: 2, wakeUp: .calm, wakeWindow: .calm, signs: .crying, note: "a")
        ]
        let callback: (Result<[LifeCycle], Error>) -> () = { result in
            switch result {
                //Then
                    // После маппинга:
                    // - ожидаю корректный тип данных (success)
                    // - проверяю возможность работы с данными итерируя их
                    // - дополнительно проверяю корректность полученных данных сравнивая каждый id с ожидаемым результатом
            case let .success(lc):
                lc.forEach {
                    XCTAssertTrue($0.id == expectedResult[$0.index].id)
                }
            case let .failure(error):
                XCTFail("Failed, error == \(error)")
            }
        }
        // When
        network.request(decoderType: LifeCycleNetworkEntity.self,callback)
    }
    
    
  func test_networkRequestWith_emptyArrayResult() throws {
         //Given
         let data = emptyResultJson
         let network = NetworkRepositoryDTOMapper(client: ApiCLientStub(result: .success(data)))
         let expectedResult: [LifeCycle] = []
         let callback: (Result<[LifeCycle], Error>) -> () = { result in
             switch result {
                //Then
                    // После маппинга:
                    // - ожидаю корректный тип данных (success)
                    // - сравниваю количество полученных элементов с ожидаемым результатом
             case let .success(lc):
                XCTAssertTrue(lc.count == expectedResult.count)
             case let .failure(error):
                XCTFail("Failed, error == \(error)")
             }
         }
         // When
         network.request(decoderType: LifeCycleNetworkEntity.self, callback)
     }
}



class ApiCLientStub: ApiClientProtocol {
    
    let result: (Result<Data, Error>)
    
    init(result: (Result<Data, Error>)) {
        self.result = result
    }
    
    func execute(callback: @escaping (Result<Data, Error>) -> ()) {
        callback(result)
    }
    
}


private let lifecyclesResultJson: Data = {
    let str =
"""
   {
      "dreams": [ {
          "index":0,
          "id":"4B38EFC7-CD93-4D16-9137-0399AD15E6C0",
          "putDown":"На груди",
          "fallAsleep":"😭",
          "note": "b",
          "date":"2021-11-03"
      },
      {
          "index":1,
          "id":"7BB1077F-5C22-4259-838D-DCF49E296989",
          "putDown":"На груди",
          "fallAsleep":"😭",
          "note": "c",
          "date":"2021-11-03"
      }],
        "wakes": [{
            "index":2,
            "id":"37F1CFBB-C4A6-4F36-924F-884D859F6F2C",
            "wakeUp":"🙂",
            "wakeWindow":"Спокойно",
            "signs":"Плакал",
            "note": "a",
            "date":"2021-11-03"
        }],
    }
"""
    let data = str.data(using: .utf8)
    return data!
}()


private let emptyResultJson: Data = {
    let str =
"""
   {
      "wakes": [],
      "dreams": []
  }
"""
    let data = str.data(using: .utf8)
    return data!
}()
