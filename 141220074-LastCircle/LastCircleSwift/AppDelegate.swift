//
//  AppDelegate.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import UIKit
import CloudKit

let recordType = "RTYPE_BEST"
let recordName = "RNAME_BEST"
let recordKey = "RKEY_BEST"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wbToken: String?
    var cloudRecord: CKRecord?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        CKContainer.default().accountStatus(completionHandler: { (status, error) -> Void in
            if (status == CKAccountStatus.noAccount) {
                print("iCloud no account when fetching")
            } else {
                let recordID = CKRecordID(recordName: recordName)
                let container = CKContainer.default()
                let publicDatabase = container.publicCloudDatabase
                publicDatabase.fetch(withRecordID: recordID, completionHandler: { (record, error) -> Void in
                    if error == nil {
                        if let rec = record {
                            self.cloudRecord = rec
                            print("iCloud fetch successed")
                            let cloudBest = rec[recordKey] as! Int
                            if cloudBest > ScoreManager.sharedManager.best {
                                ScoreManager.sharedManager.best = cloudBest
                            }
                        }
                    } else {
                        print("iCloud fetch failed: \(error)")
                    }
                })
            }
        })

        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // iCloud saving
        CKContainer.default().accountStatus(completionHandler: { (status, error) -> Void in
            if (status == CKAccountStatus.noAccount) {
                print("iCloud no account when saving")
            } else {
                let recordID = CKRecordID(recordName: recordName)
                var record = self.cloudRecord
                
                if record == nil {
                    record = CKRecord(recordType: recordType, recordID: recordID)
                }
                record![recordKey] = ScoreManager.sharedManager.best as CKRecordValue?
                let container = CKContainer.default()
                let publicDatabase = container.publicCloudDatabase
                publicDatabase.save(record!, completionHandler: { (record, error) -> Void in
                    if error == nil {
                        print("iCloud save successed")
                    } else {
                        print("iCloud save failed: \(error)")
                    }
                })
            }
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

