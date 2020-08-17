//
//  UIsearchBar+Activity.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 16.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    // MARK: Private Members
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    private var searchIcon: UIImage? {
         let subViews = subviews.flatMap { $0.subviews }
         return  ((subViews.filter { $0 is UIImageView }).first as? UIImageView)?.image
     }
    
    // MARK: Public Members
    var textField: UITextField? {
        return searchTextField
    }

    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            let _searchIcon = searchIcon
            if newValue {
                if activityIndicator == nil {
                    let _activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                    _activityIndicator.startAnimating()
                    _activityIndicator.backgroundColor = UIColor.clear
                    
                    let clearImage = UIColor.clear.image(CGSize(width: 19.5, height: 19.5))
                    self.setImage(clearImage, for: .search, state: .normal)
                    textField?.leftViewMode = .always
                    textField?.leftView?.addSubview(_activityIndicator)
                    let leftViewSize = CGSize.init(width: 19.5, height: 19.5)
                    _activityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                self.setImage(_searchIcon, for: .search, state: .normal)
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
