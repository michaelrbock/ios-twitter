//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Michael Bock on 2/20/16.
//  Copyright © 2016 Michael R. Bock. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageURL!)!)
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true

        tweetTextView.delegate = self

        tweetTextView.textColor = UIColor.grayColor()
        tweetTextView.layer.cornerRadius = 5
        tweetTextView.layer.borderColor = UIColor.blackColor().CGColor
        tweetTextView.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tweetTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    @IBAction func onCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSendButton(sender: UIBarButtonItem) {
        let params = ["status": tweetTextView.text]
        TwitterClient.sharedInstance.updateStatusWithParams(params)

        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "What's happening?" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.stringByReplacingCharactersInRange(range, withString: text)
        let tweetLength = 140 - newText.characters.count
        characterCountLabel.text = "\(tweetLength)"
        return tweetLength <= 140
    }
}
