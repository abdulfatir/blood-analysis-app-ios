//
//  ResultsController.swift
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 09/08/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

import UIKit
import Charts

class RedResultsController: UIViewController {
    
    @IBOutlet weak var combinedChart: CombinedChartView!
    var samples = [CGRect]()
    var conc = [150.0, 175.0, 200.0, 225.0, 250.0, 300.0]
    var reds = [Double]()
    var NO_OF_RECTS = 7
    
    @IBOutlet weak var results: UITextView!
    @IBOutlet weak var equation: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = UserDefaults.standard
        if(prefs.object(forKey: "cardMode") != nil){
            if(prefs.integer(forKey: "cardMode") == 1){
                NO_OF_RECTS = 6
                conc = prefs.array(forKey: "fiveStandards") as! [Double]
            }
            else{
                NO_OF_RECTS = 7
                conc = prefs.array(forKey: "sixStandards") as! [Double]
            }
        }
        
        conc = Array(conc[0...1]) + Array(conc[3...NO_OF_RECTS-2])
        
        for i in 0 ..< samples.count-1 {
            if(i != 2){
                reds.append(Double(samples[i].origin.y))
            }
        }
        print(conc.count, reds.count)
        updateGraph()
    }
    
    
    func updateGraph(){
        let linRegress = LinearRegression(x: conc, reds)
        equation.text = String(format: "y = %.4f x + %.2f", linRegress.slope, linRegress.intercept)
        
        let intensity = Double(samples[NO_OF_RECTS-1].origin.y)
        let concentration = (intensity - linRegress.intercept)/linRegress.slope
        let qcIntensity = Double(samples[2].origin.y)
        let qcConc = (qcIntensity - linRegress.intercept)/linRegress.slope
        let error = abs(qcConc - conc[2])*100/conc[2]
        
        var resultsText = "Quality Control\n"
        resultsText.append(String(format:"Conc: %.2f\n", qcConc))
        resultsText.append(String(format:"Error: %.2f%%\n", error))
        resultsText.append("Unknown\n")
        resultsText.append(String(format:"Conc: %.2f\n", concentration))
        resultsText.append(String(format:"R2 Score: %.4f", linRegress.r2))
        
        let attribString = NSMutableAttributedString(string: resultsText)
        attribString.addAttribute(NSFontAttributeName, value: UIFont(name:"HelveticaNeue", size:13.0)!, range: (resultsText as NSString).range(of: resultsText))
        attribString.addAttribute(NSFontAttributeName, value: UIFont(name:"HelveticaNeue-Bold", size:14.0)!, range: (resultsText as NSString).range(of: "Quality Control"))
        attribString.addAttribute(NSFontAttributeName, value: UIFont(name:"HelveticaNeue-Bold", size:14.0)!, range: (resultsText as NSString).range(of: "Unknown"))
        results.attributedText = attribString
        
        
        var knownEntries = [ChartDataEntry]()
        var unknownEntries = [ChartDataEntry]()
        var standardEntries = [ChartDataEntry]()
        for i in 0 ..< reds.count{
            let point = ChartDataEntry(x: conc[i], y: reds[i])
            knownEntries.append(point)
        }
        unknownEntries.append(ChartDataEntry(x: concentration, y: intensity))
        
        for i in stride(from: 0, to: 500, by: 5){
            let point = ChartDataEntry(x: Double(i), y: linRegress.evaluate(x: Double(i)))
            standardEntries.append(point)
        }
        
        let dataset1 = ScatterChartDataSet(values: knownEntries, label: "Known")
        dataset1.setScatterShape(ScatterChartDataSet.Shape.circle)
        dataset1.setColor(NSUIColor.red)
        dataset1.scatterShapeSize = 7.5
        dataset1.drawValuesEnabled = false
        
        let dataset2 = ScatterChartDataSet(values: unknownEntries, label: "Unknown")
        dataset2.setScatterShape(ScatterChartDataSet.Shape.circle)
        dataset2.setColor(NSUIColor.gray)
        dataset2.scatterShapeSize = 7.5
        dataset2.drawValuesEnabled = false
        
        let dataset3 = LineChartDataSet(values: standardEntries, label: "Standard Curve")
        dataset3.setColor(NSUIColor.blue)
        dataset3.lineWidth = 2
        dataset3.drawCirclesEnabled = false
        dataset3.drawCircleHoleEnabled = false
        
        let scatterData = ScatterChartData()
        scatterData.addDataSet(dataset1)
        scatterData.addDataSet(dataset2)
        
        let lineData = LineChartData()
        lineData.addDataSet(dataset3)
        
        let combinedData = CombinedChartData()
        combinedData.scatterData = scatterData
        combinedData.lineData = lineData
        
        combinedChart.rightAxis.enabled = false
        let yAxis = combinedChart.leftAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 255
        yAxis.drawGridLinesEnabled = false
        let xAxis = combinedChart.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 500
        combinedChart.data = combinedData
        combinedChart.chartDescription?.text = "Standard Graph"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func gotoHome(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }

}
