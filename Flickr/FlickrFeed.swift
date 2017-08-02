//
//  FlickrPostItem.swift
//  Flickr
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import Foundation

class FlickrFeed {
    
    var title: String = ""
    var link: String = ""
    var description: String = ""
    var modified: String = ""
    var generator: String = ""
    
    
    init(){
        // Empty initializer
    }
    
    init(title: String, link: String, description: String, modified: String, generator: String) {
        self.title = title
        self.link = link
        self.description = description
        self.modified = modified
        self.generator = generator
    }
    
}
