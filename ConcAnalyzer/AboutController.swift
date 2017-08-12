//
//  AboutController.swift
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 12/08/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet weak var credits: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let icHome = "home"
        let icInfo = "info"
        let icSettings = "settings"
        let icCamera = "camera"
        let icons8 = "icons8"
        let icMaker = "Madebyoliver"
        let icLicense = "CC 3.0 BY"
        var creds = "This app uses icons \(icHome), \(icInfo), \(icSettings), and \(icCamera) from \(icons8) and icons made by \(icMaker) from www.flaticon.com is licensed by \(icLicense). "
        creds.append("This app also uses Charts by Daniel Cohen Gindi.\n\nLICENSE (for Charts)\n\n")
        let license = "Copyright 2016 Daniel Cohen Gindi & Philipp Jahoda\n\nLicensed under the Apache License, Version 2.0 (the \"License\"); you may not use this file except in compliance with the License. You may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software distributed under the License is distributed on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License."
        creds.append(license)
        
        let attribString = NSMutableAttributedString(string: creds)

        attribString.addAttribute(NSLinkAttributeName, value: "https://icons8.com/icon/14096/Home", range: (creds as NSString).range(of: icHome))
        attribString.addAttribute(NSLinkAttributeName, value: "https://icons8.com/icon/77/Info", range: (creds as NSString).range(of: icInfo))
        attribString.addAttribute(NSLinkAttributeName, value: "https://icons8.com/icon/364/Settings", range: (creds as NSString).range(of: icSettings))
        attribString.addAttribute(NSLinkAttributeName, value: "https://icons8.com/icon/5376/Camera", range: (creds as NSString).range(of: icCamera))
        attribString.addAttribute(NSLinkAttributeName, value: "https://icons8.com/", range: (creds as NSString).range(of: icons8))
        attribString.addAttribute(NSLinkAttributeName, value: "https://www.flaticon.com/authors/madebyoliver", range: (creds as NSString).range(of: icMaker))
        attribString.addAttribute(NSLinkAttributeName, value: "http://creativecommons.org/licenses/by/3.0/", range: (creds as NSString).range(of: icLicense))
        
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.justified
        attribString.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: (creds as NSString).range(of: license))
        
        
        
        
        credits.attributedText = attribString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

}
