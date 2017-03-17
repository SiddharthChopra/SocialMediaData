//
//  SocialOperationHandler.swift
//  MyCity311
//
//  Created by Piyush on 6/14/16.
//  Copyright © 2016 Kahuna Systems. All rights reserved.
//

import UIKit
import SocialMediaData

@objc public protocol SocialOperationHandlerDelegate: class {
    @objc optional func socialDataFetchSuccess()
    @objc optional func socialDataFetchError()
}


public class SocialOperationHandler: NSObject, /*YouTubeFeedDelegate, FacebookFeedDelegate,*/ TwitterFeedDelegate {

    public var socialDelegate: SocialOperationHandlerDelegate?

    var isFBLoadIsInProcess = false
    var isTwitterLoadIsInProcess = false
    var isYoutubeLoadIsInProcess = false

    var isFacebookFirstTime = false
    var isTwitterFirstTime = false
    var isYouTubeFirstTime = false
    var isLoadFromServer = false

    var twitterURL = String()
    var serverBaseURL = String()
    var tweetAccessToken = String()
    var tweetSecretKey = String()
    var tweetConsumerKey = String()
    var tweetConsumerSecret = String()
    var tweetOwnerSecretName = String()
    var tweetSlugName = String()


    public static let sharedInstance = SocialOperationHandler()

    override init() {
    }

    public func initAllKeys(twitterURL: String, serverBaseURL: String, tweetAccessToken: String, tweetSecretKey: String, tweetConsumerKey: String, tweetConsumerSecret: String, tweetOwnerSecretName: String, tweetSlugName: String) {
        self.serverBaseURL = serverBaseURL
        self.twitterURL = twitterURL
        self.tweetAccessToken = tweetAccessToken
        self.tweetSecretKey = tweetSecretKey
        self.tweetConsumerKey = tweetConsumerKey
        self.tweetConsumerSecret = tweetConsumerSecret
        self.tweetOwnerSecretName = tweetOwnerSecretName
        self.tweetSlugName = tweetSlugName
    }


    deinit {
        print("** SocialOperationHandler deinit called **")
    }

    func getFacebookFeeds() {
        /*if self.checkCurrentProccessIsGoingOn() {
            return
        }
        if CheckConnectivity.hasConnectivity() {
            self.isFBLoadIsInProcess = true
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fbPublicHandler = FacebookPublicFeedsHandler.sharedInstance
            fbPublicHandler.fBFeedFetchDelegate = self
            if appDelegate.configrationInfo.isLoadFromServer {
                fbPublicHandler.getFacebookFeedListFromURL(Constants.ServiceEndPoints.getFacebookList)
            } else {
                if appDelegate.configrationInfo.fbURL.characters.count > 0 {
                    fbPublicHandler.getPublicFeedsFromUserName(appDelegate.configrationInfo.fbURL)
                } else {
                    fbPublicHandler.getPublicFeedsFromUserName(SocialConstants.facebookGraphURL)
                }
            }
        } else {
            self.noConnectivityReset()
        }*/
    }

    public func getTwitterFeeds() {
        if self.checkCurrentProccessIsGoingOn() {
            return
        }
        if CheckConnectivity.hasConnectivity() {
            self.isTwitterLoadIsInProcess = true
            let twitterPublicHandler = TwitterPublicFeedsHandler.sharedInstance
            twitterPublicHandler.twitterDelegate = self
            if isLoadFromServer {
                twitterPublicHandler.getTwitterFeedListFromURL(Constants.ServiceEndPoints.getTwitterList)
            } else {
                if twitterURL.characters.count > 0 {
                    twitterPublicHandler.getLatestTweetsFromServerWithURLString(twitterURL)
                } else {
                    twitterPublicHandler.getLatestTweetsFromServerWithURLString(Constants.kTweetUrl)
                }
            }
        } else {
            self.noConnectivityReset()
        }
    }

    func getYouTubeFeeds() {
        /*if self.checkCurrentProccessIsGoingOn() {
            return
        }
        if CheckConnectivity.hasConnectivity() {
            self.isYoutubeLoadIsInProcess = true
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let youTubePublicHandler = YouTubePublicFeedsHandler.sharedInstance
            youTubePublicHandler.youTubeDelegate = self
            if appDelegate.configrationInfo.isLoadFromServer {
                youTubePublicHandler.getYouTubeFeedListFromURL(Constants.ServiceEndPoints.getYoutubeList)
            } else {
                var loadWithoutSubscriptions = false
                if appDelegate.configrationInfo.isLoadFromSubscriptions == nil {
                    loadWithoutSubscriptions = true
                } else if appDelegate.configrationInfo.isLoadFromSubscriptions.characters.count > 0 {
                    if Int(appDelegate.configrationInfo.isLoadFromSubscriptions) == 1 {
                        loadWithoutSubscriptions = true
                    }
                }
                if loadWithoutSubscriptions {
                    if appDelegate.configrationInfo.youTubeURL.characters.count > 0 {
                        youTubePublicHandler.getYouTubeFeedsFromURL(appDelegate.configrationInfo.youTubeURL)
                    } else {
                        youTubePublicHandler.getYouTubeFeedsFromURL(SocialConstants.kYoutubeUrl)
                    }
                } else {
                    youTubePublicHandler.getUsersSubscriptionsData()
                }
            }
        } else {
            self.noConnectivityReset()
        }*/
    }

    //MARK:- YouTubeFeedDelegate Methods
    func youTubeFeedFetchSuccess(_ feedArray: NSArray?) {
        self.isYoutubeLoadIsInProcess = false
        self.isYouTubeFirstTime = true
        if self.socialDelegate != nil {
            self.socialDelegate?.socialDataFetchSuccess!()
        }
    }

    func youTubeFeedFetchError(_ error: NSError?) {
        self.isYoutubeLoadIsInProcess = false
        self.isYouTubeFirstTime = true
        if self.socialDelegate != nil {
            self.socialDelegate?.socialDataFetchError!()
        }
    }

    //MARK:- TwitterFeedDelegate Methods
    func twitterFeedFetchSuccess(_ feedArray: NSArray?) {
        self.isTwitterLoadIsInProcess = false
        self.isTwitterFirstTime = true
        if self.socialDelegate != nil {
            self.socialDelegate?.socialDataFetchSuccess!()
        }
    }

    func twitterFeedFetchError(_ errorType: NSError?) {
        self.isTwitterLoadIsInProcess = false
        self.isTwitterFirstTime = true
        if self.socialDelegate != nil {
            self.socialDelegate?.socialDataFetchError!()
        }
    }

    //MARK:- FacebookFeedDelegate Methods
    func facebookFeedFetchSuccess(_ feedArray: NSArray?) {
        self.isFBLoadIsInProcess = false
        self.isFacebookFirstTime = true
        if self.socialDelegate != nil {
            self.socialDelegate?.socialDataFetchSuccess!()
        }
    }

    func facebookFeedFetchError(_ errorType: NSError) {
        self.isFBLoadIsInProcess = false
        self.isFacebookFirstTime = true
        if self.socialDelegate != nil {
            self.socialDelegate?.socialDataFetchError!()
        }
    }

    func checkCurrentProccessIsGoingOn() -> Bool {
        var isProcessRunning = false
        if self.isFBLoadIsInProcess {
            isProcessRunning = true
        } else if self.isTwitterLoadIsInProcess {
            isProcessRunning = true
        } else if self.isYoutubeLoadIsInProcess {
            isProcessRunning = true
        }
        if isProcessRunning && self.socialDelegate != nil {
            let ViewC = self.socialDelegate as? UIViewController
            if ViewC != nil {
                DispatchQueue.main.async {
                    //MBProgressHUD.hideAllHUDsForView(ViewC?.view, animated: true)
                }
            }
        }
        return isProcessRunning
    }

    public func fetchTwitterDataInfoFromDB() -> NSMutableArray {
        let responseArray = NSMutableArray()
        let coredataHandler = CoreDataManager.sharedInstance() as CoreDataManager
        if let tempArray = coredataHandler.objects(Constants.coreDataTableKeys.kTwitterFeedInfor) as? NSArray {
            for i in 0 ..< tempArray.count {
                let coreDataObj = tempArray[i] as? TweetInfo
                let dataObj = TwitterDataInfo()
                dataObj.tweeterUserId = coreDataObj?.tweeterUserId
                dataObj.tweetId = coreDataObj?.tweetId
                dataObj.profileIcon = coreDataObj?.profileIcon
                dataObj.tweetText = coreDataObj?.tweetText
                dataObj.tweeterUserName = coreDataObj?.tweeterUserName
                dataObj.tweetDate = coreDataObj?.tweetDate
                responseArray.add(dataObj)
            }
        }
        return responseArray
    }

    /*public func fetchYoutubeDataInfoFromDB() -> NSMutableArray {
        let responseArray = NSMutableArray()
        let coredataHandler = CoreDataManager.sharedInstance() as CoreDataManager
        if let tempArray = coredataHandler.objects(Constants.coreDataTableKeys.kYoutubeInterface) as? NSArray {
            for i in 0 ..< tempArray.count {
                let coreDataObj = tempArray[i] as? YoutubeInterface
                let dataObj = YouTubeInterfaceDataInfo()
                dataObj.updatedDateTime = coreDataObj?.updatedDateTime
                dataObj.youtubeAuthor = coreDataObj?.youtubeAuthor
                dataObj.youtubeDescription = coreDataObj?.youtubeDescription
                dataObj.youtubeImage = coreDataObj?.youtubeImage
                dataObj.youtubeLink = coreDataObj?.youtubeLink
                dataObj.youtubeTime = coreDataObj?.youtubeTime
                dataObj.youtubeTitle = coreDataObj?.youtubeTitle
                dataObj.youtubeViews = coreDataObj?.youtubeViews
                responseArray.addObject(dataObj)
            }
        }
        return responseArray
    }

    public func fetchFacebookDataInfoFromDB() -> NSMutableArray {
        let responseArray = NSMutableArray()
        let coredataHandler = CoreDataManager.sharedInstance() as CoreDataManager
        if let tempArray = coredataHandler.objects(Constants.coreDataTableKeys.kFacebookFeedInfo) as? NSArray {
            for i in 0 ..< tempArray.count {
                let coreDataObj = tempArray[i] as? FacebookFeedInfo
                let dataObj = FacebookFeedDataInfo()
                dataObj.fbAuthorName = coreDataObj?.fbAuthorName
                dataObj.fbCommentsCount = coreDataObj?.fbCommentsCount
                dataObj.fbCreatedTime = coreDataObj?.fbCreatedTime
                dataObj.fbDescription = coreDataObj?.fbDescription
                dataObj.fbFeedId = coreDataObj?.fbFeedId
                dataObj.fbLikesCount = coreDataObj?.fbLikesCount
                dataObj.fbMessage = coreDataObj?.fbMessage
                dataObj.fbPostPictureLink = coreDataObj?.fbPostPictureLink
                dataObj.fbPostType = coreDataObj?.fbPostType
                dataObj.fbSharesCount = coreDataObj?.fbSharesCount
                dataObj.fbTitle = coreDataObj?.fbTitle
                dataObj.fbUpdatedTime = coreDataObj?.fbUpdatedTime
                dataObj.fbUserIcon = coreDataObj?.fbUserIcon
                dataObj.fbUserId = coreDataObj?.fbUserId
                dataObj.fbVideoLink = coreDataObj?.fbVideoLink
                responseArray.addObject(dataObj)
            }
        }
        return responseArray
    }*/

    func noConnectivityReset() {
        self.isFBLoadIsInProcess = false
        self.isTwitterLoadIsInProcess = false
        self.isYoutubeLoadIsInProcess = false
        if self.socialDelegate != nil {
            self.socialDelegate?.socialDataFetchError!()
        }
    }

}
