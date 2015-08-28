//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Javier San Juan Cervera on 25/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    var tweet: Tweet? {
        didSet {
            // Fill array of sections
            if tweet != nil {
                if tweet!.media.count > 0 { sections.append(.Media(tweet!.media)) }
                if tweet!.hashtags.count > 0 { sections.append(.Hashtags(tweet!.hashtags.map { return $0.keyword })) }
                if tweet!.urls.count > 0 { sections.append(.URLs(tweet!.urls.map { return $0.keyword })) }
                if tweet!.userMentions.count > 0 { sections.append(.UserMentions(tweet!.userMentions.map { return $0.keyword })) }
            } else {
                sections = [Section]()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionForIndex(section)?.name ?? "!ERROR"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionForIndex(section)?.numberOfItems ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = sectionForIndex(indexPath.section)!
        switch section {
        case .Media:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MentionsImageCellReuseIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            if let url = tweet?.media[indexPath.row].url {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    if let imageData = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.tweetImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MentionsTextCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = sectionForIndex(indexPath.section)?.stringForItem(indexPath.row)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = sectionForIndex(indexPath.section)!
        switch section {
        case .Media:
            return tableView.bounds.size.width / CGFloat(tweet!.media[indexPath.row].aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = sectionForIndex(indexPath.section)!
        switch section {
        case .Media:
            performSegueWithIdentifier(Storyboard.ImageSegue, sender: indexPath)
            break
        case .Hashtags, .UserMentions:
            performSegueWithIdentifier(Storyboard.TweetsSegue, sender: indexPath)
        case .URLs:
            if let url = NSURL(string: tweet!.urls[indexPath.row].keyword) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: - Sections
    
    private var sections = [Section]()
    
    private enum Section {
        case Media([MediaItem])
        case Hashtags([String])
        case URLs([String])
        case UserMentions([String])
        
        var numberOfItems: Int {
            switch self {
            case .Media(let mediaItems):
                return mediaItems.count
            case .Hashtags(let items):
                return items.count
            case .URLs(let items):
                return items.count
            case .UserMentions(let items):
                return items.count
            }
        }
        
        var name: String {
            switch self {
            case .Media: return "Media"
            case .Hashtags: return "Hashtags"
            case .URLs: return "URLs"
            case .UserMentions: return "User Mentions"
            }
        }
        
        func stringForItem(item: Int) -> String {
            switch self {
            case .Media(let mediaItems):
                return mediaItems[item].url.absoluteString ?? ""
            case .Hashtags(let items):
                return items[item]
            case .URLs(let items):
                return items[item]
            case .UserMentions(let items):
                return items[item]
            }
        }
    }
    
    private func sectionForIndex(index: Int) -> Section? {
        if index >= 0 && index < sections.count {
            return sections[index]
        } else {
            return nil
        }
    }
    
    private var numberOfSections: Int {
        var number = 0
        if tweet?.media.count > 0 { ++number }
        if tweet?.hashtags.count > 0 { ++number }
        if tweet?.urls.count > 0 { ++number }
        if tweet?.userMentions.count > 0 { ++number }
        return number
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = sender as? NSIndexPath {
            if let section = sectionForIndex(indexPath.section) {
                // Destination is TweetTableViewController
                if let tweetVC = segue.destinationViewController as? TweetTableViewController {
                    tweetVC.searchText = section.stringForItem(indexPath.row)
                // Destination is ImageViewController
                } else if let imageVC = segue.destinationViewController as? ImageViewController {
                    if let url = NSURL(string: section.stringForItem(indexPath.row)) {
                        imageVC.imageURL = url
                    }
                }
            }
        }
    }
}
