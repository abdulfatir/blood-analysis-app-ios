//
//  SettingsController.swift
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 10/08/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var standard1: UITextField!
    @IBOutlet weak var standard2: UITextField!
    @IBOutlet weak var standard3: UITextField!
    @IBOutlet weak var standard4: UITextField!
    @IBOutlet weak var standard5: UITextField!
    @IBOutlet weak var standard6: UITextField!
    @IBOutlet weak var label6: UILabel!
    
    
    let cardTypes = ["Cholesterol/6-Ref", "Glucose/5-Ref"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentCardMode = 0
        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "cardMode") != nil){
            currentCardMode = preferences.integer(forKey: "cardMode")
        }
        if(currentCardMode == 0){
            pickerView.selectRow(0, inComponent: 0, animated: false)
            showSixthStandard()
            loadSixStandards()
        }
        else if(currentCardMode == 1){
            pickerView.selectRow(1, inComponent: 0, animated: false)
            hideSixthStandard()
            loadFiveStandards()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cardTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cardTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0){
            showSixthStandard()
            loadSixStandards()
        }
        else if(row == 1){
            hideSixthStandard()
            loadFiveStandards()
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func saveClicked(_ sender: Any) {
        let preferences = UserDefaults.standard
        if(pickerView.selectedRow(inComponent: 0) == 0){
            let standards = [Double(standard1.text!),Double(standard2.text!),Double(standard3.text!),Double(standard4.text!),Double(standard5.text!),Double(standard6.text!)]
            preferences.set(standards, forKey: "sixStandards")
        }
        else if(pickerView.selectedRow(inComponent: 0) == 1){
            let standards = [Double(standard1.text!),Double(standard2.text!),Double(standard3.text!),Double(standard4.text!),Double(standard5.text!)]
            preferences.set(standards, forKey: "fiveStandards")
        }
        let currentCardMode = pickerView.selectedRow(inComponent: 0)
        preferences.set(currentCardMode, forKey: "cardMode")
        preferences.synchronize()
        self.dismiss(animated: true, completion: {})
    }
    
    func hideSixthStandard(){
        label6.isHidden = true
        standard6.isHidden = true
    }
    
    func showSixthStandard(){
        label6.isHidden = false
        standard6.isHidden = false
    }
    
    func loadSixStandards(){
        var standards = [150.0, 175.0, 200.0, 225.0, 250.0, 300.0]
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "sixStandards") != nil){
            standards = preferences.array(forKey: "sixStandards") as! [Double]
        }
        
        standard1.text = String(standards[0])
        standard2.text = String(standards[1])
        standard3.text = String(standards[2])
        standard4.text = String(standards[3])
        standard5.text = String(standards[4])
        standard6.text = String(standards[5])
    }
    
    func loadFiveStandards(){
        var standards = [50.0, 75.0, 100.0, 125.0, 150.0]
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "fiveStandards") != nil){
            standards = preferences.array(forKey: "fiveStandards") as! [Double]
        }
        
        standard1.text = String(standards[0])
        standard2.text = String(standards[1])
        standard3.text = String(standards[2])
        standard4.text = String(standards[3])
        standard5.text = String(standards[4])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
