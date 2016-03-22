//
//  SurveyTask.swift
//
//  Created by Shashank Kothapalli on 7/16/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//

import ResearchKit

/* Different kind of survey tasks to ask many different questions of a patient. Only goes through multi choice and number answer format*/
public var SurveyTask: ORKOrderedTask {
    var steps = [ORKStep] ()
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.image = UIImage(named: ("LeftB.png"))
    instructionStep.title = "How are you feeling today?"
    instructionStep.text = "First, we'd like to ask you some questions about your Migraine pain"
    
    steps += [instructionStep]

/******************* QUESTION-1 *****************/
    //let numberAnswerFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.Integer)
    let nameQuestionStepTitle = "Do you have Migraine now?"
    let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: ORKAnswerFormat.booleanAnswerFormat())
    steps += [nameQuestionStep]

/******************* QUESTION-2 *****************/
    
    let questQuestionStepTitle = "How long do you have this Migraine?"
    let textChoices = [
        ORKTextChoice(text: "Not now", value: 0),
        ORKTextChoice(text: "> 1 Hour", value:1),
        ORKTextChoice(text: "> 2 Hours", value:2),
        ORKTextChoice(text: "> 4 Hours", value:4),
        ORKTextChoice(text: "> 8 Hours", value:8),
        ORKTextChoice(text: "> Whole Day", value:24),
    ]
    

    
    
    
   /******************* QUESTION-3 *****************/

    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
    steps += [questQuestionStep];
    
    let heartQuestionStepTitle = "Which part of your head gives you more head ache?"
    let heartChoices = [
        ORKTextChoice(text: "Left", value: 0),
        ORKTextChoice(text: "Right", value:1),
        ORKTextChoice(text: "Front", value: 2),
        ORKTextChoice(text: "Back",value:3),
        ORKTextChoice(text: "Top",value:4),
        ORKTextChoice(text: "All",value:5),
    ]
    
    
    let heartAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: heartChoices)
    let heartQuestionStep = ORKQuestionStep(identifier: "HeartChoiceQuestionStep", title: heartQuestionStepTitle, answer: heartAnswerFormat)
    steps += [heartQuestionStep]
    
    
    /******************* QUESTION-4 *****************/
    

    let Q4StepTitle = "How do you classify your Migrine?"
    let Q4Choices = [
        ORKTextChoice(text: "Throbbing", value: 0),
        ORKTextChoice(text: "Pulzating", value:1),
        ORKTextChoice(text: "Others", value: 2)
    ]
    
    
    let Q4AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: Q4Choices)
    let Q4QuestionStep = ORKQuestionStep(identifier: "Q4ChoiceQuestionStep", title: Q4StepTitle, answer: Q4AnswerFormat)
    steps += [Q4QuestionStep]
    
    
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Right. Off you go!"
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    

    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    
}
