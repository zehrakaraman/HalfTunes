//
//  SearchViewController.swift
//  HalfTunes
//
//  Created by Zehra on 17.10.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    let viewModel = SearchViewModel()
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        viewModel.delegate = self
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
        
        viewModel.getSearchResults(searchTerm: searchText) 
        
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.idetifier, for: indexPath) as! TrackCell
        let track = viewModel.searchResults[indexPath.row]
        cell.configure(track, downloaded: false)
        return cell
    }
    
}

extension SearchViewController: SearchViewModelDelegate {
    
    func updateSearchResults() {
        self.searchResultsTableView.reloadData()
    }
    
}
