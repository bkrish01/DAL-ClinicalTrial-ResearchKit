//
//  SurveyResponse.swift
//  myHeart
//
//  Created by Nivas on 12/22/15.
//  Copyright © 2015 Shashank Kothapalli. All rights reserved.
//

import UIKit

class SurveyResponse: NSObject {
    var __class__ : String = "SurveyResponse"
    var userId : String = "8b1a33b5fedc411d884ca2cd000e2772"
    var surveyId :  String = "8"
    var timestamp : String = "\(NSDate().timeIntervalSince1970 * 1000)"
    //var response : Response!
    var duration : NSMutableDictionary!
    var severity : NSMutableDictionary!
    var location : NSMutableDictionary!
    var classification : NSMutableDictionary!
}
