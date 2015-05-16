//
//  ViewController.swift
//  testpackedobjects
//
//  Created by John Moore on 11/05/2015.
//  Copyright (c) 2015 John Moore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var data: NSData
        var xml: String
        
        let path = NSBundle.mainBundle().pathForResource("helloworld", ofType: "xsd")
        let po = PackedObjects(schema: path!)
        
        if let data = po.encode("<foo>hello</foo>") as NSData? {
            if let xml = po.decode(data) as String? {
                println(xml)
            }
        }

        if let data = po.encode("<foo>world</foo>") as NSData? {
            if let xml = po.decode(data) as String? {
                println(xml)
            }
        }
        
        // unsafe wrapping
        println(po.decode(po.encode("<foo>hello world</foo>")!)!)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

