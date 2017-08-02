//
//  FlickrFeedTableViewController.swift
//  Flickr
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit
import Kingfisher

class FlickrFeedTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate  {
    
    // MARK: Variables

    let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1" // Raw JSON required with no function wrapper. Added nojsoncallback with value 1 (https://www.flickr.com/services/api/response.json.html)
    var flickrPostItems = [FlickrPostItem]() // Array to hold the metadata for the images
    var flickrFeedMetaData = FlickrFeed() // Object to hold the metadata of the Flickr public feed (i.e. title of feed, time feed was retrieved)
    var searchController:UISearchController!
    
    @IBOutlet var spinner: UIActivityIndicatorView!

    // MARK: Table View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Flickr"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true // Saves searchBar text and state after a cell has been selected
        tableView.tableHeaderView = searchController.searchBar
        
        // Pull To Refresh
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(self.getFlickrData), for: UIControlEvents.valueChanged)
        
        // Initiate data retrieval
        getFlickrData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flickrPostItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FlickrFeedTableViewCell
        
        let value = self.flickrPostItems[indexPath.row]

        let url = URL(string: value.media)!
        
        cell.flickrPostImageView.kf.setImage(with: url)

        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let tagsToSearch = flickrURL + "&tags=" + searchText
            print(tagsToSearch)
        }
    }
    
    // MARK: Functions
    
    func getFlickrDataByTags(searchTags: String){
        let url = URL(string: flickrURL)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                self.flickrPostItems = self.parseJSONData(data: data)
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        })
        
        task.resume()
    }

    func getFlickrData(){
        let url = URL(string: flickrURL)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                
                // Load the parsed JSON data in to
                self.flickrPostItems = self.parseJSONData(data: data)
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        })
        
        task.resume()
    }
    
    func parseJSONData(data: Data) -> [FlickrPostItem] {
        
        var flickrPostItems = [FlickrPostItem]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            
            flickrFeedMetaData.title = jsonResult?["title"] as! String
            flickrFeedMetaData.link = jsonResult?["link"] as! String
            flickrFeedMetaData.description = jsonResult?["description"] as! String
            flickrFeedMetaData.modified = jsonResult?["modified"] as! String
            flickrFeedMetaData.generator = jsonResult?["generator"] as! String
            
            
            let jsonItems = jsonResult?["items"] as! [AnyObject]
            for jsonItem in jsonItems {
                
                // Created a new Flickr post object
                let newFlickrPost = FlickrPostItem()
                
                // Declaring the media child as a Dictionary to retrieve the link used to download the image
                let media = jsonItem["media"] as! NSDictionary
                for jsonItem in media {
                    newFlickrPost.media = jsonItem.value as! String
                }
                
                newFlickrPost.title = jsonItem["title"] as! String
                newFlickrPost.link = jsonItem["link"] as! String
                newFlickrPost.date_taken = jsonItem["date_taken"] as! String
                newFlickrPost.description = jsonItem["description"] as! String
                newFlickrPost.published = jsonItem["published"] as! String
                newFlickrPost.author = jsonItem["author"] as! String
                newFlickrPost.author_id = jsonItem["author_id"] as! String
                newFlickrPost.tags = jsonItem["tags"] as! String
                
                flickrPostItems.append(newFlickrPost)
            }
            
        } catch {
            print(error.localizedDescription)
            
            let alertController = UIAlertController(title: "Could not retrive data", message: "Please check your network connection and try again", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
        }
        
        return flickrPostItems
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlickrPost" || segue.identifier == "showFlickrPostInfoButton" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let value = self.flickrPostItems[indexPath.row]
                
                let url = URL(string: value.media)!
                
                let destinationController = segue.destination as! FlickrPostDetailViewController
                destinationController.flickrPostURL = url
                
                destinationController.flickrPost = value
            }
        }
    }
    

}
