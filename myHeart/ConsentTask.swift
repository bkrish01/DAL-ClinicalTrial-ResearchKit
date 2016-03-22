//
//  ConsentTask.swift
//  myResearchKit
//
//  Created by Shashank Kothapalli on 7/27/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//

import Foundation
import ResearchKit

public var ConsentTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
    //Adds the consent document to the task
    var consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]
    
    //Applies the signature
    let signature = consentDocument.signatures!.first as! ORKConsentSignature!
    
    //Review Step of Consent Form
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
    reviewConsentStep.text = "Review Consent"
    reviewConsentStep.reasonForConsent = "Consent to join the study"
    steps += [reviewConsentStep]
    
    
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}