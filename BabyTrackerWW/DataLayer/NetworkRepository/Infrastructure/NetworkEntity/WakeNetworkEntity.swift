//
//  WakeNetworkEntity.swift
//  BabyTrackerWW
//
//  Created by Max on 25.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation

 
 struct WakeNetworkEntity: Codable {
     
     let id: UUID
     let index: Int
     let wakeUp: String
     let wakeWindow: String
     let signs: String
     
     enum CodingKeys: CodingKey {
         case id
         case index
         case wakeUp
         case wakeWindow
         case signs
     }
     
    // Добавить поле дата
     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.id = try container.decode(UUID.self, forKey: .id)
         self.index = try container.decode(Int.self, forKey: .index)
         self.wakeUp = try container.decode(String.self, forKey: .wakeUp)
         self.wakeWindow = try container.decode(String.self, forKey: .wakeWindow)
         self.signs = try container.decode(String.self, forKey: .signs)
     }
     
    
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(id, forKey: .id)
         try container.encode(index, forKey: .index)
         try container.encode(wakeUp, forKey: .wakeUp)
         try container.encode(wakeWindow, forKey: .wakeWindow)
         try container.encode(signs, forKey: .signs)
     }
     
    
     func parseToDomain() throws -> Wake {
         
         guard let wakeUp = Wake.WakeUp.init(rawValue: self.wakeUp),
               let wakeWindow = Wake.WakeWindow.init(rawValue: self.wakeWindow),
               let signs = Wake.Signs.init(rawValue: self.signs)
             else { throw NetworkError.parseToDomain("Error parseToDomain(Wake)") }
         
         return .init (id: self.id,
                       index: self.index,
                       wakeUp: wakeUp,
                       wakeWindow: wakeWindow,
                       signs: signs)
     }
 }
