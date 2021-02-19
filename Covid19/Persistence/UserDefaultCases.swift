//
//  UserDefaultCases.swift
//  Covid19
//
//  Created by Kleyson on 19/02/2021.
//  Copyright © 2021 Kleyson Tavares. All rights reserved.
//

import Foundation
import CoreLocation

enum Keys: String {
    case maxCase = "case"
    case maxDeath = "death"
    case latitude = "latitude"
    case longitude = "longitude"
}

struct UserDefaultCases {
    private static let defaults = UserDefaults.standard
    
    static func salveCasesOrDeath(max: Int, key: Keys) {
        defaults.set(try? PropertyListEncoder().encode(max), forKey: key.rawValue)
    }
    
    static func salveLatitudeOrLongitude(latLng: CLLocationDegrees, key: Keys) {
        defaults.set(try? PropertyListEncoder().encode(latLng), forKey: key.rawValue)
    }
    
    static func getMaxCaseOrDeath(key: Keys) -> Int {
        if let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data {
            if let userData = try? PropertyListDecoder().decode(Int.self, from: data) {
                return userData
            }
            return 0
        } else {
            return 0
        }
    }
    
    static func getLatitudeOrLongitude(key: Keys) -> CLLocationDegrees {
        
        if let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data {
            if let userData = try? PropertyListDecoder().decode(CLLocationDegrees.self, from: data) {
                return userData
            }
            return CLLocationDegrees()
        } else {
            return CLLocationDegrees()
        }
    }
    
}
