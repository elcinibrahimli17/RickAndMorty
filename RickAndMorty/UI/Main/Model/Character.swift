//
//  Character.swift
//  RickAndMorty
//
//  Created by Elchın on 13.08.26.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationReference
    let location: LocationReference
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var isBookmarked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
}

struct LocationReference: Codable {
    let name: String
    let url: String
}

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
