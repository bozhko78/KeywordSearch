//
//  ResultCell.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 16.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell, CellModelDelegate {

    // MARK: - Outlets
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    // MARK: - Override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleImageView.backgroundColor = UIColor.lightGray
        titleImageView.layer.cornerRadius = 10
        titleImageView.image = nil
        self.contentView.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: CellModelDelegate
    func downloadFinishWith(image: UIImage) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        UIView.transition(with: titleImageView,
        duration: 0.5,
        options: .transitionCrossDissolve,
        animations: { self.titleImageView.image = image },
        completion: nil)
    }
    
    func downloadFailed() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        self.titleImageView.image = UIImage(named: "downloadFailed")
    }
}
