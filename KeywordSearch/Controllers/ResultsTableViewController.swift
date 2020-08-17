//
//  ResultsTableViewController.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 16.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import UIKit
import Combine

class ResultsTableViewController: UITableViewController {

    // MARK: Public Members
    var dataSource = [CellModel]()
    var token: AnyCancellable?
    let searchController = UISearchController(searchResultsController: nil)
    var lastSearchText = ""
    var lastSelectedScope = -1
    
    // MARK: Private Members
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Type word"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["limit 10", "limit 50", "limit 100"]
        searchController.searchBar.textField?.returnKeyType = .done
        self.tableView.tableFooterView = UIView()
        
        self.tableView.rowHeight = 100.0
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.searchBar.textField?.becomeFirstResponder()
    }
    
    // MARK: - Private Functions
    
    private func setup(cell:ResultCell, with entry:CellModel) {
        if let img = entry.img {
            cell.titleImageView.image = img
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        } else {
            cell.activityIndicator.startAnimating()
            cell.activityIndicator.isHidden = false
            cell.titleImageView.image = nil
            entry.delegate = cell
            entry.loadThumbnail()            
        }
        
        cell.titleLabel.text = entry.title
    }

            
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        let entry = dataSource[indexPath.row]
        setup(cell: cell, with: entry)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        let hasResults = !dataSource.isEmpty
        if hasResults {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No search data found"
            noDataLabel.textColor     = UIColor.darkGray
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        
        return numOfSections
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            let entry = dataSource[indexPath.row]
            entry.delegate = cell as! ResultCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            let entry = dataSource[indexPath.row]
            entry.delegate = nil
        }
    }
}

// MARK: - UISearchBarDelegate

extension ResultsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}

// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension ResultsTableViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
}


