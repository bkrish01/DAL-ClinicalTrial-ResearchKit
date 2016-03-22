//
//  Dashboard.swift
//  Patient ePRO
//
//  Created by Krishnapillai, Bala on 2/10/16.
//  Copyright © 2016 AMGEN. All rights reserved.
//

import Foundation
import UIKit

class Dashboard {
    // MARK: Properties
    
    var questions: String
    var answers: String
    var Noanswers: String
    
    // MARK: Initialization
    
    init?(questions: String, answers: String,Noanswers: String) {
        // Initialize stored properties.
        self.questions = questions
        self.answers = answers
        self.Noanswers = Noanswers
        
        // Initialization should fail if there is no name or if the rating is negative.
        if questions.isEmpty || answers.isEmpty {
            return nil
        }
    }
    
}