//
//  SearchViewModel.swift
//  HalfTunes
//
//  Created by Zehra on 17.10.2022.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func updateSearchResults()
}

class SearchViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    
    var searchResults: [Track] = []
    
    let queryService = QueryService()
    
    func getSearchResults(searchTerm: String) {
        queryService.getSearchResults(searchTerm: searchTerm) { [weak self] results, errorMessage in
            if let results = results {
                self?.searchResults = results
                self?.delegate?.updateSearchResults()
            }
            
            if !errorMessage.isEmpty {
                print("Search error: \(errorMessage)")
            }
        }
    }
}
