//
//  FlickrPostDetailViewController.swift
//  Flickr
//
//  Created by Jay Tailor on 02/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit
import Kingfisher

class FlickrPostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var flickrPostImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var flickrPostURL: URL?
    
    var flickrPost = FlickrPostItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flickrPostImageView.kf.setImage(with: flickrPostURL)
        
        print(flickrPost.author)
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FlickrPostDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Title"
            cell.valueLabel.text = flickrPost.title
        case 1:
            cell.fieldLabel.text = "Link"
            cell.valueLabel.text = flickrPost.link
        case 2:
            cell.fieldLabel.text = "Author"
            cell.valueLabel.text = flickrPost.author
        case 3:
            cell.fieldLabel.text = "AuthorID"
            cell.valueLabel.text = flickrPost.author_id
        case 4:
            cell.fieldLabel.text = "Date Taken"
            cell.valueLabel.text = flickrPost.date_taken
        case 5:
            cell.fieldLabel.text = "Description"
            cell.valueLabel.text = flickrPost.description
        case 6:
            cell.fieldLabel.text = "Published"
            cell.valueLabel.text = flickrPost.published
        case 7:
            cell.fieldLabel.text = "Tags"
            cell.valueLabel.text = flickrPost.tags
        case 8:
            cell.fieldLabel.text = "Media"
            cell.valueLabel.text = flickrPost.media
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
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
