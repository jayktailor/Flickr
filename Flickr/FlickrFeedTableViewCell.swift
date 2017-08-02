//
//  FlickrFeedTableViewCell.swift
//  Flickr
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit

class FlickrFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flickrPostImageView: UIImageView!
    @IBOutlet weak var flickrPostDescription: UILabel!
    @IBOutlet weak var flickrPostAuthor: UILabel!
    @IBOutlet weak var flickrPostTime: UILabel!
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
