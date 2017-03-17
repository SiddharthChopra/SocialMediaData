//
//  TweetInfo+CoreDataProperties.swift
//  MyCity311
//
//  Created by Piyush on 6/14/16.
//  Copyright © 2016 Kahuna Systems. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TweetInfo {

    @NSManaged var profileIcon: String?
    @NSManaged var tweetDate: String?
    @NSManaged var tweeterUserId: String?
    @NSManaged var tweeterUserName: String?
    @NSManaged var tweetId: String?
    @NSManaged var tweetText: String?

}
