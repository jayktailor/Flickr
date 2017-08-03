//
//  FlickrFeedTableViewCell.swift
//  Flickr
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit

/// Cell displays a Flickr image
class FlickrFeedTableViewCell: UITableViewCell {
    
    // MARK: TableViewCell Outlets
    @IBOutlet weak var flickrPostImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
