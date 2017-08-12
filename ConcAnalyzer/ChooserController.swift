//
//  ViewController.swift
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 20/07/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var chosenImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(OpenCVWrapper.getOpenCVVersion())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePicture(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
        
            present(imagePicker, animated: true, completion: {
            print("Choosing image.")
        })
        }
    }

    @IBAction func loadFromLibrary(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: {
            print("Choosing image.")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            chosenImage = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chosenImage = image
        }
        else{
            print("Couldn't load image.")
        }
        dismiss(animated: true, completion: {
            print("Image loaded.")
            self.performSegue(withIdentifier: "analyzerSegue", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "analyzerSegue"){
            let analyzerController = segue.destination as! AnalyzerController
            analyzerController.image = chosenImage
        }
    }
}

