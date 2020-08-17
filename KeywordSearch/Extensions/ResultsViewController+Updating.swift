//
//  ResultsTableViewController+Updating.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 16.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import UIKit

extension ResultsTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText, selectedScope: searchBar.selectedScopeButtonIndex)
        }
    }
}
