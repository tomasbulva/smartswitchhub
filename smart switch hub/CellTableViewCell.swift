//
//  CellTableViewCell.swift
//  smart switch hub
//
//  Created by Tomas Bulva on 6/14/15.
//  Copyright (c) 2015 tomasbulva. All rights reserved.
//

import UIKit
import Alamofire

class CellTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mainSwitch: UISwitch!
    
    var ipstring = ""
    
    @IBAction func cellSwitchAction(sender: UISwitch) {
        let URLHeader = "http://"
        var URLIP = ipstring // do some cleaning
        var URLCommand = ""
        
        if sender.on {
            URLCommand = "/cgi-bin/json.cgi?set=on"
        }else{
            URLCommand = "/cgi-bin/json.cgi?set=off"
        }
        
        println("address: \(URLHeader)\(URLIP)\(URLCommand)")
        
        Alamofire.request(.GET, "\(URLHeader)\(URLIP)\(URLCommand)").responseJSON() {
            (_, _, data, _) in
            println(data)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
