//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Elchın on 13.08.26.
//

import Foundation

protocol CharacterListViewModelDelegate: AnyObject {
    func didUpdateCharacters()
    func didFailWithError(_ message: String)
}

final class CharacterListViewModel {
    
    weak var delegate: CharacterListViewModelDelegate?
    
    private let networkService = NetworkService()
    
    private var allCharacters: [Character] = []
    private(set) var filteredCharacters: [Character] = []
    
    private var currentSearchText: String = ""
    private var selectedGender: String?
    
    let filterTitles = ["Gender Types", "Classifications", "Status"]
    
    var numberOfCharacters: Int {
        filteredCharacters.count
    }
    
    func character(at index: Int) -> Character {
        filteredCharacters[index]
    }
    
    func fetchCharacters() {
        networkService.getData(urlString: "https://rickandmortyapi.com/api/character") { [weak self] (result: Result<CharacterResponse, NetworkError>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.allCharacters = response.results
                    self.applyFilters()
                case .failure(let error):
                    self.delegate?.didFailWithError(error.errorMessage)
                }
            }
        }
    }
    
    func search(with text: String) {
        currentSearchText = text
        applyFilters()
    }
    
    func selectGender(_ gender: String?) {
        selectedGender = gender
        applyFilters()
    }
    
    var currentGenderTitle: String {
        selectedGender ?? filterTitles[0]
    }
    
    private func applyFilters() {
        var result = allCharacters
        
        if !currentSearchText.isEmpty {
            result = result.filter { $0.name.lowercased().contains(currentSearchText.lowercased()) }
        }
        
        if let selectedGender {
            result = result.filter { $0.gender.lowercased() == selectedGender.lowercased() }
        }
        
        filteredCharacters = result
        delegate?.didUpdateCharacters()
    }
}
