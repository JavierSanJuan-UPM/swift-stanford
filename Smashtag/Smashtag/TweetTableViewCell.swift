//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Javier San Juan Cervera on 17/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        //tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            var tweetText = tweet.text
            for _ in tweet.media {
                tweetText += " 📷"
            }
            
            // Set text attributes
            let attributedString = NSMutableAttributedString(string: tweetText)
            for hashtagKeyword in tweet.hashtags {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: hashtagKeyword.nsrange)
            }
            for urlKeyword in tweet.urls {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.brownColor(), range: urlKeyword.nsrange)
            }
            for mentionKeyword in tweet.userMentions {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: mentionKeyword.nsrange)
            }
            
            // Set tweet text
            tweetTextLabel.attributedText = attributedString
            
            // Set tweet user
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            // Set profile image
            self.tweetProfileImageView?.image = nil
            if let profileImageURL = tweet.user.profileImageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue()) {
                            if self.tweet?.user.profileImageURL != nil && profileImageURL == self.tweet!.user.profileImageURL! {
                                self.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
            
            /*
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            */
        }
    }
}
