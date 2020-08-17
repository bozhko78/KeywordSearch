//
//  ResultsTableViewController+DataSource.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 16.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import UIKit

extension ResultsTableViewController {
    
    // MARK: Private Functions
    private func limitBySelectedScope(index:Int) -> Int {
        var limit = 0
        
        if 0 == index {
            limit = 10
        } else if 1 == index {
            limit = 50
        } else if 2 == index {
            limit = 100
        } else {
            limit = 10
        }
        return limit
    }

    // MARK: Public Functions
    func filterContentForSearchText(_ searchText: String, selectedScope:Int ) {
        self.searchController.searchBar.isLoading = true
        guard searchText.count > 2 else {
            self.dataSource.removeAll()
            self.tableView.reloadData()
            self.searchController.searchBar.isLoading = false
            return
        }
        
        if searchText == lastSearchText, selectedScope == lastSelectedScope {
            self.searchController.searchBar.isLoading = false
            return
        }

        lastSearchText = searchText
        lastSelectedScope = selectedScope
        let limit = limitBySelectedScope(index: selectedScope)
        
        token?.cancel()
        let originalString = "https://search.outdoorsy.co/rentals?address=Austin+Texas+United+States&filter[keywords]=\(searchText)&page[limit]=\(limit)&page[offset]=0"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlStr = urlString, let url = URL(string:urlStr) else {
            self.searchController.searchBar.isLoading = false
            return
        }
                
        token = URLSession.shared.dataTaskPublisher(for: url)
            //.receive(on: RunLoop.main)
        .sink(receiveCompletion: { (completion) in
        switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.dataSource.removeAll()
                    self.tableView.reloadData()
                    self.searchController.searchBar.isLoading = false
                }
            }
        }) { (result: SearchResult) in
            var tempDataSource = [CellModel]()
            result.data.forEach({
                let imageId = $0.relationships.primary_image.data.id
                let title = $0.attributes.name
                                    
                let extra = result.included.first { (elem) -> Bool in
                    return elem.id == imageId
                }
                
                let urlString = extra?.attributes.url
                
                let model = CellModel()
                model.title = title
                model.urlString = urlString
                if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
                    model.img = imageFromCache as? UIImage
                }
                
                tempDataSource.append(model)
            })
            
            DispatchQueue.main.async {
                self.dataSource = tempDataSource
                                    
                self.tableView.reloadData()
                self.searchController.searchBar.isLoading = false
            }
        }
    }
}
