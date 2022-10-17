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
        
    }
    
}
