//
//  ConsentDocument.swift
//  myResearchKit
//
//  Created by Shashank Kothapalli on 7/27/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//


import Foundation
import ResearchKit

/* Sections for the consent document, could be modified according to documentation online*/
public var ConsentDocument: ORKConsentDocument {
    
    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Example Consent"
    consentDocument.signaturePageTitle = "Consent Signature"
    consentDocument.signaturePageContent = NSLocalizedString("I agree to participate in this research study.", comment: "")
    
    let consentSectionTypes: [ORKConsentSectionType] = [
        .Overview,
        .DataGathering,
        .DataUse,
        .TimeCommitment,
        .Withdrawing
    ]
    
    var sections = [ORKConsentSection]()
    
    let overviewSection = ORKConsentSection(type: ORKConsentSectionType.Overview)
    overviewSection.summary = "This study is going to be used by Amgen."
    overviewSection.content = "Please note that only the data will be released to who are mentioned in the following sections."
    sections += [overviewSection]
    
    let dataGatheringSection = ORKConsentSection(type: ORKConsentSectionType.DataGathering)
    dataGatheringSection.summary = "We hope this study is not only useful to help contribute data to help others around the world but also useful to you to help understand your condition better"
    dataGatheringSection.content = "Surveys should be easy and will not take more than 5 minutes a week."
    sections += [dataGatheringSection]
    
    let dataUseSection = ORKConsentSection(type: ORKConsentSectionType.DataUse)
    dataUseSection.summary = "We will collect only information that will be pertinent to the study."
    dataUseSection.content = "You will be able to follow your weekly answers by visiting the online webpage"
    sections += [dataUseSection]
    
    let timeCommitmentSection = ORKConsentSection(type: ORKConsentSectionType.TimeCommitment)
    timeCommitmentSection.summary = "The surveys will be quick and should not hinder you from doing whatever you do on a normal day"
    timeCommitmentSection.content = "There is a lot more to this study on the online webpage if you choose to spend more time"
    sections += [timeCommitmentSection]
    
    let withdrawingSection = ORKConsentSection(type: ORKConsentSectionType.Withdrawing)
    withdrawingSection.summary = "You can withdraw at any point and stop contributing your information. Previously supplied data will be kept in our database."
    withdrawingSection.content = "Just click on the delete button in the profile tab."
    sections += [withdrawingSection]
    
    consentDocument.sections = sections
    
    let htmlFile = NSBundle.mainBundle().pathForResource("test", ofType: "html")
    let htmlString = try? String(contentsOfFile: htmlFile!, encoding: NSUTF8StringEncoding)
    
    //consentDocument.htmlReviewContent = "<html><head><title>Page Title</title></head><body><h1>This is a Heading</h1><p>This is a paragraph.</p></body></html>"
    consentDocument.htmlReviewContent = htmlString
    
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: "Participant", dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
   
    return consentDocument
    
}
