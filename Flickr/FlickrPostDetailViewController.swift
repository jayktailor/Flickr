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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flickrPostImageView.kf.setImage(with: flickrPostURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
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
