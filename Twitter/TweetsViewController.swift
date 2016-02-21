//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Michael Bock on 2/19/16.
//  Copyright © 2016 Michael R. Bock. All rights reserved.
//

import MBProgressHUD
import UIKit

class TweetsViewController: UIViewController {

    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]! = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        refreshControl.addTarget(self, action: "getTimelineData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        getTimelineData()
    }

    func getTimelineData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
}

extension TweetsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell

        cell.tweet = tweets[indexPath.row]

        return cell
    }
}

extension TweetsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false

        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailViewController.tweet = tweets[indexPath.row]

        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
