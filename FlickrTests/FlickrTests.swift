//
//  FlickrTests.swift
//  FlickrTests
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import XCTest
@testable import Flickr

class FlickrTests: XCTestCase {
    
    var flickrFeed: FlickrFeed!
    var flickPostItem: FlickrPostItem!
    let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    var flickrPostItems = [FlickrPostItem]() // Array to hold the metadata for the images
    var flickrFeedMetaData = FlickrFeed()
    
    override func setUp() {
        super.setUp()
        
//        flickrFeed = FlickrFeed(title: "Uploads from everyone",
//                                link: "https:\\/\\/www.flickr.com\\/photos\\/",
//                                description: "",
//                                modified: "2017-08-02T14:38:01Z",
//                                generator: "https:\\/\\/www.flickr.com")
        
        testGetFlickrData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetFlickrData(){
        let url = URL(string: flickrURL)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                
                // Load the parsed JSON data in to
                self.testParseJSONData(data: data)
                
                XCTAssert(data != nil, "Success")
                
            }
        })
        
        task.resume()
    }
    
    func testParseJSONData(data: Data){
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            XCTAssert(jsonResult != nil, "Successlly parsed JSON")
            
        } catch {
            
            print(error.localizedDescription)
            
            
        }
        
    }

    
    
    
}
