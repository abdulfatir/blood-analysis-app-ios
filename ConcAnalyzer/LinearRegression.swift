//
//  LinearRegression.swift
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 12/08/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

import UIKit

class LinearRegression: NSObject {
    
    var slope: Double!
    var intercept: Double!
    var r2: Double!
    
    init(x: [Double], _ y: [Double]) {
        super.init()
        let sum1 = average(input: multiply(input1: x, y)) - average(input: x) * average(input: y)
        let sum2 = average(input: multiply(input1: x, x)) - pow(average(input: x), 2)
        self.slope = sum1 / sum2
        self.intercept = average(input: y) - slope * average(input: x)
        let ybar = average(input: y)
        var yybar: Double = 0.0
        var ssr: Double = 0.0
        for i in 0..<y.count{
            yybar += (y[i] - ybar)*(y[i] - ybar)
            let fit = evaluate(x: x[i])
            ssr += (fit - ybar) * (fit - ybar)
        }
        self.r2 = ssr/yybar
    }
    
    func average(input: [Double]) -> Double {
        return input.reduce(0, +) / Double(input.count)
    }
    
    func multiply(input1: [Double], _ input2: [Double]) -> [Double] {
        return input1.enumerated().map({ (index, element) in return element*input2[index] })
    }
    
    func evaluate(x: Double) -> Double {
        return self.slope*x + self.intercept
    }
}
