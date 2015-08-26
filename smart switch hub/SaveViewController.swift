//
//  SaveViewController.swift
//  smart switch hub
//
//  Created by Tomas Bulva on 6/10/15.
//  Copyright (c) 2015 tomasbulva. All rights reserved.
//

import UIKit
import Alamofire

class SaveViewController: UIViewController {
    
    @IBOutlet weak var ipstring: UITextField!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var testSwitch: UISwitch!
    
    
    @IBAction func testButtonAction(sender: UISwitch) {
        let URLHeader = "http://"
        var URLIP = ipstring.text // do some cleaning
        var URLCommand = ""
        
        if sender.on {
            URLCommand = "/cgi-bin/json.cgi?set=on"
        }else{
            URLCommand = "/cgi-bin/json.cgi?set=off"
        }
        
        println("address: \(URLHeader)\(URLIP)\(URLCommand)")
        
        Alamofire.request(.GET, "\(URLHeader)\(URLIP)\(URLCommand)").responseJSON() {
            (a, b, data, c) in
            println("testButtonAction \(a)")
            println("testButtonAction \(b)")
            println("testButtonAction \(data)")
            println("testButtonAction \(c)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
