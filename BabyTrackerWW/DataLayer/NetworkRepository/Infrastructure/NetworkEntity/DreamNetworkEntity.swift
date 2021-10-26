//
//  NetworkEntity.swift
//  BabyTrackerWW
//
//  Created by Max on 25.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation

  
  struct DreamNetworkEntity: Codable {
      let id: UUID
      let index: Int
      let fallAsleep: String
      let putDown: String
      
      enum CodingKeys: CodingKey {
          case id
          case index
          case fallAsleep
          case putDown
      }
      
      // Добавить поле дата
      init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.id = try container.decode(UUID.self, forKey: .id)
          self.index = try container.decode(Int.self, forKey: .index)
          self.fallAsleep = try container.decode(String.self, forKey: .fallAsleep)
          self.putDown = try container.decode(String.self, forKey: .putDown)
      }
      
      
      func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(id, forKey: .id)
          try container.encode(index, forKey: .index)
          try container.encode(fallAsleep, forKey: .fallAsleep)
          try container.encode(putDown, forKey: .putDown)
      }
      
      
      func parseToDomain() throws -> Dream {
          
          guard let fallAsleep = Dream.FallAsleep.init(rawValue: self.fallAsleep),
                let putDown = Dream.PutDown.init(rawValue: self.putDown)
              else { throw NetworkError.parseToDomain("Error parseToDomain(Dream)") }
          
          return .init (id: self.id,
                        index: self.index,
                        putDown: putDown,
                        fallAsleep: fallAsleep)
      }
  }

