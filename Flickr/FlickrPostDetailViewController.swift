//
//  FlickrPostDetailViewController.swift
//  Flickr
//
//  Created by Jay Tailor on 02/08/2017.
//  Copyright © 2017 Jay Tailor. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices
import MessageUI

class FlickrPostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    // MARK: View Controller Outlets
    @IBOutlet weak var flickrPostImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var flickrPostURL: URL?
    var flickrPost = FlickrPostItem()
    let numberOfRowsInSection = 9
    
    // MARK: Table View Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        flickrPostImageView.kf.setImage(with: flickrPostURL)
        
        // Setting the estimated row height of the cells and allowing automatic dimentions for self-sizing cells
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set up the right button on the navigation bar to bring up the menu
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FlickrPostDetailTableViewCell
        
        // Populate the table with the image metadata
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
    
    // MARK: Functions
    
    /// Shows menu with the following options: Share, Save image, Open in browser. User can share the image via email when selecting Share.
    func actionButtonTapped() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        // Share image via email
        let emailImage = { (action:UIAlertAction!) -> Void in
            
            let image = self.flickrPostImageView.image
            
            // Stored the image in a variable to be opened by the activity view controller
            let emailImageToShare = [image!]
            let activityViewController = UIActivityViewController(activityItems: emailImageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            // Present the activity view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        let emailImageAction = UIAlertAction(title: "Share", style: .default, handler: emailImage)
        optionMenu.addAction(emailImageAction)
        
        
        // Save image to device gallery
        let contactUs = { (action:UIAlertAction!) -> Void in
            UIImageWriteToSavedPhotosAlbum(self.flickrPostImageView.image!, nil, nil, nil)
        }
        let contactUsAction = UIAlertAction(title: "Save image", style: .default, handler: contactUs)
        optionMenu.addAction(contactUsAction)
        
        
        // Open image in browser
        let privacyPolicy = { (action:UIAlertAction!) -> Void in
            if let url = URL(string: self.flickrPost.link) {
                let safariController = SFSafariViewController(url: url)
                self.present(safariController, animated: true, completion: nil)
            }
        }
        let privacyPolicyAction = UIAlertAction(title: "Open in browser", style: .default, handler: privacyPolicy)
        optionMenu.addAction(privacyPolicyAction)
        
        // Show menu with the options above
        self.present(optionMenu, animated: true, completion: nil)
    }

}
