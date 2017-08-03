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
    
    let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    override func setUp() {
        super.setUp()
        
        testGetFlickrData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
                XCTAssert(!data.isEmpty, "Successlly retreived data from Flickr servers")
                
                self.testParseJSONData(data: data)
            }
        })
        
        task.resume()
    }
    
    func testParseJSONData(data: Data){
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            print(jsonResult!)
            
            XCTAssert(jsonResult != nil, "Successlly parsed JSON")
        } catch {
            print(error.localizedDescription)
        }
    }
}
