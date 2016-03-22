//
//  StepsViewController.swift
//  myHeart
//
//  Created by Shashank Kothapalli on 8/26/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//

import UIKit
import Charts

class StepsViewController: UIViewController {

    @IBAction func back(sender: UIButton) {
        dates = [String]()
        stepsOver = [Double]()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart(dates, values: stepsOver)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Steps Taken")
        let chartData = BarChartData(xVals: dates, dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.descriptionText = ""
        
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        barChartView.xAxis.labelPosition = .Bottom
        
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/225, blue: 199/255, alpha: 1)
    }


}
