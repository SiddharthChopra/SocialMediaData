//
//  TweetInfo.swift
//  MyCity311
//
//  Created by Piyush on 6/14/16.
//  Copyright © 2016 Kahuna Systems. All rights reserved.
//

import CoreData
import Foundation
@objc(TweetInfo)

public class TweetInfo: NSManagedObject {
    
    @NSManaged var profileIcon: String?
    @NSManaged var tweetDate: String?
    @NSManaged var tweeterUserId: String?
    @NSManaged var tweeterUserName: String?
    @NSManaged var tweetId: String?
    @NSManaged var tweetText: String?
    
}
