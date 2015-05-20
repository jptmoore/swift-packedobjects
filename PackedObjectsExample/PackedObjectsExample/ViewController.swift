//
//  ViewController.swift
//  testpackedobjects
//
//  Created by John Moore on 11/05/2015.
//  Copyright (c) 2015 John Moore. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var xmlView: UITextView!
    @IBOutlet weak var xmlPicker: UIPickerView!
    
    var xmlfiles : [String] = []
    var path : String = ""
    var schemaFile : String = ""
    var xml : String = ""
    
    @IBAction func runTest(sender: AnyObject) {
        performTest(schemaFile, xml: xml)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return xmlfiles.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return xmlfiles[row]
    }
    
    func outputSelection(schemaFile: String, xml: String) {
        let po = PackedObjects(schema: schemaFile)
        if let data = po.encode(xml) as NSData? {
            if let result = po.decode(data) as String? {
                xmlView.text = result
            }
        }
    }
    
    func performTest(schemaFile: String, xml: String) {
        let po = PackedObjects(schema: schemaFile)
        let start = NSDate()
        for _ in 1...1000 {
            let data = po.encode(xml)
            let result = po.decode(data!)
        }
        let end = NSDate()
        let timeInterval: Double = end.timeIntervalSinceDate(start)
        xmlView.text = "Test completed in \(timeInterval) seconds\n"
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let filename = xmlfiles[row]
        let prefix = split(filename) {$0 == "."}[0]
        xml = String(contentsOfFile: path+filename, encoding: NSUTF8StringEncoding, error: nil)!
        schemaFile = path + prefix + ".xsd"
        outputSelection(schemaFile, xml: xml)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        xmlView.text = ""
        let fileManager = NSFileManager.defaultManager()
        path = NSBundle.mainBundle().bundlePath + "/"
        let files = fileManager.contentsOfDirectoryAtPath(path, error: nil) as? [String]
        xmlfiles = files!.filter({$0.hasSuffix(".xml")})

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

