//
//  DataAccessGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 14.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


final class DataAccessGateway: LifeCyclesCardGateway {
    
    struct DataAccessError: Error {
        var description = [String]()
    }

    private let network: NetworkRepositoryConfiguratorProtocol
    private let localStorage: PersistenceRepositoryProtocol

    init(apiConfigurator: NetworkRepositoryConfiguratorProtocol, localStorage: PersistenceRepositoryProtocol) {
        self.network = apiConfigurator
        self.localStorage = localStorage
    }
    // создать сущность для конфига нетворк реквеста (енд поинт/путь, тип запроса, хедеры, боди). В зависимости от метода вызывать тот или иной метод сущности (фетч, адд и т.д.)
    // далее на основании полученного конфига создавать нетворк реквест (в следующей сущности) и отправлять его в сеть
    
    func fetchLifeCycle(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        
        var resultError = DataAccessError()
        var resultSuccess = [LifeCycle]()
        
//        let dreamTask = network.request(with: networkConfig.fetchDreams()) { result in ... }
        let dreamsTask = network.fetchDreams().fetchRequest { result1 in }
//            switch result1 {
//            case let .success(dreams): localStorage.synchronize(lifeCycle: dreams, date: date) { result in
//                switch result {
//                case .success(_): callback(result1)
//                case let .failure(error): callback(error)
//                }
            // Продумать ход выполнения блоков в функциях, чтобы не было дикой пирамиды (нужна прямая передача один блок в другой, без реализации)
            // Все чаще прихожу к выводу, что нужен слой с дата мапингом ...
//
//                print("lifeCycle.parseToDomain()")
//            //
//            //
//            //
//            default: print("End")
                    
        //networkCall
        //caching result in persistence repo
        //
    }
    
    
    
    
    func addNewLifeCycle(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
    }
    
    func changeLifeCycle(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        
    }
    
    func deleteLifeCycle(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        
    }
    
    
}



