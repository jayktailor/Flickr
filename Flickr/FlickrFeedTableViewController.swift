//
//  FlickrFeedTableViewController.swift
//  Flickr
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit
import Kingfisher


/// Displays only the images from the API request and tag searches
class FlickrFeedTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate  {
    
    // MARK: View Controller Outlets
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    // MARK: Variables
    
    /// Raw JSON required with no function wrapper. Added nojsoncallback with value 1 (https://www.flickr.com/services/api/response.json.html)
    let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    var flickrPostItems = [FlickrPostItem]() // Array to hold the metadata for the images
    var flickrPostItemsSearch = [FlickrPostItem]()
    
    
    /// Object to hold the metadata of the Flickr public feed (i.e. title of feed, time feed was retrieved)
    var flickrFeedMetaData = FlickrFeed()
    var searchController:UISearchController!
    let numberOfSectionsInTable = 1

    // MARK: Table View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Flickr"
        
        // Set up the search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by tags (i.e. fly,plane)"
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true // Saves searchBar text and state after a cell has been selected
        tableView.tableHeaderView = searchController.searchBar
        
        // Pull To Refresh
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(self.refreshTable), for: UIControlEvents.valueChanged)
        
        // Initiate data retrieval
        getFlickrData()
        
        // Added a spinner to the center of the table view
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        tableView.addSubview(spinner)
        spinner.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSectionsInTable
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchController.isActive) ? self.flickrPostItemsSearch.count : self.flickrPostItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FlickrFeedTableViewCell
        
        var value = FlickrPostItem()
        
        // Check if user has begun search
        if searchController.isActive {
            
            // Check if the Flick search array is empty - if true return an empty cell.
            if flickrPostItemsSearch.isEmpty == true {
                return cell
            } else {
                value = flickrPostItemsSearch[indexPath.row]
            }
        } else {
            value = self.flickrPostItems[indexPath.row]
        }
        
        // Retrieve the Flickr post URL to download the image or retrieve image from cache
        let url = URL(string: value.media)!
        cell.flickrPostImageView.kf.setImage(with: url)

        return cell
    }
    
    // MARK: Search Functions
    
    /// Used to determine when the user has tapped Cancel
    ///
    /// - Parameter searchBar: A text field control for text-based searches
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchController.searchBar.text != "" {
            if let searchText = searchController.searchBar.text {
                let tagsToSearch = flickrURL + "&tags=" + searchText
                self.getFlickrDataByTags(searchTags: tagsToSearch)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Disables the spacebar. User is unable to send a malformed URL.
        if text == " " || text == "\\" || text == "&" || text == "@" || text == "\"" || text == "?" || text == "!" {
            return false
        }
        
        return true
    }
    
    /// Check if the search bar text is empty. If true reload the data from the flickrPostItems array
    ///
    /// - Parameter searchController: searchController is used to determine whether search is empty
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            self.tableView.reloadData()
        }
    }
    
    /// getFlickrDataByTags is called when the user has entered search text and tapped the Search button
    ///
    /// - Parameter searchTags: Contains the search text (i.e. fly,plane). Special characters ( ,\,&,@,",?!) are not includede in search before search is performed
    ///
    func getFlickrDataByTags(searchTags: String){
        let url = URL(string: searchTags)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                
                // Clear the search array everytime a new search has begun
                self.flickrPostItemsSearch.removeAll()
                self.flickrPostItemsSearch = self.parseJSONData(data: data)
                
                // Add the table reload to the operation queue. Only reloads table when JSON data has been retrieved
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    if let refreshControl = self.refreshControl {
                        if refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                        }
                    }
                })
            }
        })
        
        task.resume()
    }
    
    
    /// Used to determine when the user has tapped Cancel
    ///
    /// - Parameter searchBar: A text field control for text-based searches
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.flickrPostItemsSearch.removeAll()
        self.tableView.reloadData()
        self.spinner.stopAnimating()
        if let refreshControl = self.refreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: Functions
    
    
    /// Called when users pulls to refresh table
    func refreshTable() {
        spinner.startAnimating()
        getFlickrData()
        spinner.stopAnimating()
    }
    
    /// Retrieve the Flickr public feed JSON
    func getFlickrData(){
        let url = URL(string: flickrURL)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                
                // Show an alert if there is no network connection
                let alertController = UIAlertController(title: "Search failed", message: "We can't find what you're looking for. Try searching for something else.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if let data = data {
                
                // Load the parsed JSON data into array
                self.flickrPostItems = self.parseJSONData(data: data)
                
                // Add the table reload to the operation queue. Only reloads table when JSON data has been retrieved
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    if let refreshControl = self.refreshControl {
                        if refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                        }
                    }
                })
            }
        })
        
        task.resume()
    }
    
    /// Parses the raw JSON data from the API request (https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1)
    ///
    /// - Parameter data: Raw JSON
    /// - Returns: Array of FlickrPostItem objects
    func parseJSONData(data: Data) -> [FlickrPostItem] {
        
        // New array of Flickr posts returned to populate table
        var flickrPostItems = [FlickrPostItem]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            // Save the Flickr Feed metadata
            flickrFeedMetaData.title = jsonResult?["title"] as! String
            flickrFeedMetaData.link = jsonResult?["link"] as! String
            flickrFeedMetaData.description = jsonResult?["description"] as! String
            flickrFeedMetaData.modified = jsonResult?["modified"] as! String
            flickrFeedMetaData.generator = jsonResult?["generator"] as! String
            
            let jsonItems = jsonResult?["items"] as! [AnyObject]
            
            // Parse over the JSON and store objects in an array
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
            
            // Show an alert if there is no network connection
            let alertController = UIAlertController(title: "Could not retrive data", message: "Please check your network connection and try again", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            
            print(error.localizedDescription)
        }
        
        return flickrPostItems
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlickrPost"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let value = (searchController.isActive) ? flickrPostItemsSearch[indexPath.row] : self.flickrPostItems[indexPath.row]
                
                let url = URL(string: value.media)!
                
                let destinationController = segue.destination as! FlickrPostDetailViewController
                destinationController.flickrPostURL = url
                destinationController.flickrPost = value
            }
        }
    }
    

}
