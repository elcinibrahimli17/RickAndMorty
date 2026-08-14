//
//  BookmarkManager.swift
//  RickAndMortyApp
//
//  Created by Elchın on 12.08.26.
//

import Foundation

enum BookmarkManager {
    
    static func isBookmarked(id: Int) -> Bool {
        UserDefaults.standard.bookmarkedIDs.contains(id)
    }
    
    static func toggleBookmark(id: Int) {
        var current = UserDefaults.standard.bookmarkedIDs
        if current.contains(id) {
            current.remove(id)
        } else {
            current.insert(id)
        }
        UserDefaults.standard.bookmarkedIDs = current
    }
}
