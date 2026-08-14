//
//  Userdefaults+Extension.swift
//  RickAndMortyApp
//
//  Created by Elchın on 12.08.26.
//

import Foundation

extension UserDefaults {
    enum Keys: String {
        case bookmarkedCharacterIDs = "bookmarkedCharacterIDs"
    }
    
    var bookmarkedIDs: Set<Int> {
        get {
            let array = array(forKey: Keys.bookmarkedCharacterIDs.rawValue) as? [Int] ?? []
            return Set(array)
        }
        set {
            setValue(Array(newValue), forKey: Keys.bookmarkedCharacterIDs.rawValue)
        }
    }
}

