//
//  Gender.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 19/12/22.
//

import Foundation

enum Gender : String, RawRepresentable, CaseIterable, Decodable {
    
    case male, female, other
    
    static func index(of aGender: Gender) -> Int {
            let elements = [Gender.male, Gender.female, Gender.other]

            return elements.index(of: aGender)!
        }
    
    static func element(at index: Int) -> Gender? {
          let elements = [Gender.male, Gender.female, Gender.other]

          if index >= 0 && index < elements.count {
              return elements[index]
          } else {
              return nil
          }
      }
    
}
