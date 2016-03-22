//
//  TwoFingerTappingTask.swift
//
//  Created by Shashank Kothapalli on 7/16/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//

import ResearchKit

//TwoFingerTappingTask
public var TwoFingerTappingTask: ORKOrderedTask {
    return ORKOrderedTask.twoFingerTappingIntervalTaskWithIdentifier("FingerTask", intendedUseDescription: "Try to tap as steadily as possible", duration: 20, options: ORKPredefinedTaskOption(rawValue: 0))
}
