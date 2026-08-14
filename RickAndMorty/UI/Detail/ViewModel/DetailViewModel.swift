//
//  DetailViewModel.swift
//  RickAndMorty
//
//  Created by Elchın on 13.08.26.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func didUpdateBookmark(isBookmarked: Bool)
}

final class DetailViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    
    let character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    var name: String {
        character.name
    }
    
    var imageURL: String {
        character.image
    }
    
    var infoFields: [(title: String, value: String)] {
        [
            ("Gender", character.gender),
            ("Status", character.status),
            ("Species", character.species),
            ("Type", character.type),
            ("Origin", character.origin.name)
        ]
    }
    
    var isBookmarked: Bool {
        BookmarkManager.isBookmarked(id: character.id)
    }
    
    func toggleBookmark() {
        BookmarkManager.toggleBookmark(id: character.id)
        delegate?.didUpdateBookmark(isBookmarked: isBookmarked)
    }
}
