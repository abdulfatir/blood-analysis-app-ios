//
//  AnalyzerController.swift
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 20/07/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

import UIKit

class AnalyzerController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var analyzeButton: UIButton!
    var image: UIImage!
    var samples = [CGRect]()
    @IBOutlet weak var failedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        failedLabel.isHidden = true
        if image != nil{
            imageView.image = image
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func analyzeImage(_ sender: Any) {
        let openCVwrapper = OpenCVWrapper()
        let processedImage = openCVwrapper.analyzeCard(fixOrientation(img: imageView.image!))
        if(processedImage != nil){
            imageView.image = processedImage
            analyzeButton.isEnabled = false
            samples = openCVwrapper.getFinalSamples() as! [CGRect]
            self.performSegue(withIdentifier: "tabbedResultsSegue", sender: self)
        }
        else{
            failedLabel.isHidden = false
            analyzeButton.isEnabled = false
        }
        
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
    
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
    @IBAction func gotoHome(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let tabController = segue.destination as! UITabBarController
        let redResultsController = tabController.viewControllers?[0] as! RedResultsController
        let greenResultsController = tabController.viewControllers?[1] as! GreenResultsController
        let blueResultsController = tabController.viewControllers?[2] as! BlueResultsController
        redResultsController.samples = self.samples
        greenResultsController.samples = self.samples
        blueResultsController.samples = self.samples
    }

}
