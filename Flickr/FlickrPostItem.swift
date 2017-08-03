//
//  FlickrPostItem.swift
//  Flickr
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import Foundation

/// Class object holding all the metadata for the image
class FlickrPostItem {
    
    var title: String = ""
    var link: String = ""
    var media: String = ""
    var date_taken: String = ""
    var description: String = ""
    var published: String = ""
    var author: String = ""
    var author_id: String = ""
    var tags: String = ""
    
    init(){
        // Empty initializer
    }
    
    init(title: String, link: String, media: String, date_taken: String, description: String, published: String, author: String, author_id: String, tags: String) {
        self.title = title
        self.link = link
        self.media = media
        self.date_taken = date_taken
        self.description = description
        self.published = published
        self.author = author
        self.author_id = author_id
        self.tags = tags
    }
    
}
