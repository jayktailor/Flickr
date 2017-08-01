//
//  FlickrFeedTableViewController.swift
//  Flickr
//
//  Created by Jay Tailor on 01/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit

class FlickrFeedTableViewController: UITableViewController {
    
    // MARK: Variables
    let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1" // Raw JSON required with no function wrapper. Added nojsoncallback with value 1 (https://www.flickr.com/services/api/response.json.html)
    var flickrPostItems = [FlickrPostItem]()
    var flickrFeedMetaData = FlickrFeed()
    

    // MARK: Table View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFlickrData()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flickrPostItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FlickrFeedTableViewCell
        
        let value = self.flickrPostItems[indexPath.row]

        let url = URL(string: value.link)!
        print(url)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    
    // MARK: Functions

    func getFlickrData(){
        guard let url = URL(string: flickrURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            // Parse JSON data
            if let data = data {
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
                
                let media = jsonItem["media"] as! NSDictionary
                
                let newFlickrPost = FlickrPostItem()
                
                newFlickrPost.title = jsonItem["title"] as! String
                newFlickrPost.link = jsonItem["link"] as! String
                newFlickrPost.date_taken = jsonItem["date_taken"] as! String
                newFlickrPost.description = jsonItem["description"] as! String
                newFlickrPost.published = jsonItem["published"] as! String
                newFlickrPost.author = jsonItem["author"] as! String
                newFlickrPost.author_id = jsonItem["author_id"] as! String
                newFlickrPost.tags = jsonItem["tags"] as! String
                
                for jsonItem in media {
                    newFlickrPost.media = jsonItem.value as! String
                }
                
                print(newFlickrPost.link)
                
                flickrPostItems.append(newFlickrPost)
                
                
            }
            
        } catch {
            print(error)
        }
        
        return flickrPostItems
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
