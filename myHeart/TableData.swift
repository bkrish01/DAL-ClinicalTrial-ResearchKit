//
//  TableData.swift
//  DevCon
//
//  Created by Krishnapillai, Bala on 2/19/16.
//  Copyright © 2016 AMGEN. All rights reserved.
//

import Foundation
import UIKit

class TableData{
    
    /*
    [["elevation": <null>, "utc_offset": -08:00, "water": 0, "floors": <null>, "timestamp": 2016-02-16T08:00:00+00:00, "last_updated": 2016-02-16T21:12:41+00:00, "source": fitbit, "validated": 0, "distance": 1620.88, "_id": 56c361ebb6182240d20655cb, "calories_burned": 1223, "steps": 2164, "source_name": Fitbit]]
    */
    var eQuestionaire : NSString!
    var eYes :String!
    var eNo :String!
    // MARK: Initialization
    
    init?(eQuestionaire: String, eYes: String, eNo: String) {
        // Initialize stored properties.
        self.eQuestionaire = eQuestionaire
        self.eYes = eYes
        self.eNo = eNo
        
        // Initialization should fail if there is no name or if the rating is negative.
        if eQuestionaire.isEmpty {
            return nil
        }
    }
    
    
    init?(source_data: NSDictionary) {
        // Initialize stored properties.
        self.eQuestionaire = source_data["eQuestionaire"]! as! String
        self.eYes = source_data["eYes"]! as! String
        self.eNo = source_data["eNo"]! as! String
        
        // Initialization should fail if there is no name or if the rating is negative.
        if eNo.isEmpty || eYes.isEmpty {
            return nil
        }
    }

    
    
}
