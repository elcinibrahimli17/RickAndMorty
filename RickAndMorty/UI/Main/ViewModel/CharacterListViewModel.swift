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
    private let baseURL = "https://rickandmortyapi.com/api/character"
    
    private(set) var filteredCharacters: [Character] = []
    
    private var currentSearchText: String = ""
    private var selectedGender: String?
    private var selectedSpecies: String?
    private var selectedStatus: String?
    
    private var searchTimer: Timer?
    private var nextPageURL: String?
    private var isLoadingNextPage = false
    
    let filterTitles = ["Gender Types", "Classifications", "Status"]
    
    var numberOfCharacters: Int {
        filteredCharacters.count
    }
    
    func character(at index: Int) -> Character {
        filteredCharacters[index]
    }
    
    var currentGenderTitle: String {
        selectedGender ?? filterTitles[0]
    }
    
    var currentSpeciesTitle: String {
        selectedSpecies ?? filterTitles[1]
    }
    
    var currentStatusTitle: String {
        selectedStatus ?? filterTitles[2]
    }
    
    func fetchCharacters() {
        nextPageURL = nil
        
        var components = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = []
        
        if !currentSearchText.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: currentSearchText))
        }
        if let selectedGender {
            queryItems.append(URLQueryItem(name: "gender", value: selectedGender))
        }
        if let selectedSpecies {
            queryItems.append(URLQueryItem(name: "species", value: selectedSpecies))
        }
        if let selectedStatus {
            queryItems.append(URLQueryItem(name: "status", value: selectedStatus))
        }
        
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = components?.url else {
            delegate?.didFailWithError(NetworkError.badURL.errorMessage)
            return
        }
        
        networkService.getData(urlString: url.absoluteString) { [weak self] (result: Result<CharacterResponse, NetworkError>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.filteredCharacters = response.results
                    self.nextPageURL = response.info.next
                    self.delegate?.didUpdateCharacters()
                case .failure(let error):
                    if case .notFound = error {
                        self.filteredCharacters = []
                        self.nextPageURL = nil
                        self.delegate?.didUpdateCharacters()
                    } else {
                        self.delegate?.didFailWithError(error.errorMessage)
                    }
                }
            }
        }
    }
    
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard currentIndex >= filteredCharacters.count - 4 else { return }
        guard let nextPageURL, !isLoadingNextPage else { return }
        
        isLoadingNextPage = true
        
        networkService.getData(urlString: nextPageURL) { [weak self] (result: Result<CharacterResponse, NetworkError>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.isLoadingNextPage = false
                
                switch result {
                case .success(let response):
                    self.filteredCharacters.append(contentsOf: response.results)
                    self.nextPageURL = response.info.next
                    self.delegate?.didUpdateCharacters()
                case .failure(let error):
                    self.delegate?.didFailWithError(error.errorMessage)
                }
            }
        }
    }
    
    func search(with text: String) {
        currentSearchText = text
        
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.fetchCharacters()
        }
    }
    
    func selectGender(_ gender: String?) {
        selectedGender = gender
        fetchCharacters()
    }
    
    func selectSpecies(_ species: String?) {
        selectedSpecies = species
        fetchCharacters()
    }
    
    func selectStatus(_ status: String?) {
        selectedStatus = status
        fetchCharacters()
    }
}
