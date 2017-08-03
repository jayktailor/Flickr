//
//  FlickrPostDetailTableViewCell.swift
//  Flickr
//
//  Created by Jay Tailor on 02/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit

/// Cell displays the Flickr image metadata
class FlickrPostDetailTableViewCell: UITableViewCell {
    
    // MARK: TableViewCell Outlets
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
