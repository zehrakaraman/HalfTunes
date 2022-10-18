//
//  SearchViewController.swift
//  HalfTunes
//
//  Created by Zehra on 17.10.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    let queryService = QueryService()
    var searchResults: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Half Tunes"
    }

}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
            if let results = results {
                self?.searchResults = results
                self?.searchResultsTableView.reloadData()
            }
            
            if !errorMessage.isEmpty {
                print("Search error: \(errorMessage)")
            }
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.idetifier, for: indexPath) as! TrackCell
        let track = searchResults[indexPath.row]
        cell.configure(track, downloaded: false)
        return cell
    }
    
}
