//
//  ViewController.swift
//  InternetInfo
//
//  Created by AndyJobs.Lin on 2018/5/22.
//  Copyright © 2018年 AndyJobs. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController {


    
    @IBOutlet weak var SSIDName: UILabel!
    @IBOutlet weak var ErrorMsg: UILabel!
    @IBOutlet weak var CheckPunch: UIButton!
    
    var SSID: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ErrorMsg.text = nil
        SSID = fetchSSIDInfo()
        if(SSID == nil)
        {
            SSIDName.text = "無Wi-Fi連線"
            SSIDName.textColor = UIColor.red
        }
        else
        {
            SSIDName.textColor = UIColor.black
            SSIDName.text = SSID!
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func CheckPunch(_ sender: Any) {
        
        ErrorMsg.text = "打卡成功"
        
        
    }
    
    
    func fetchSSIDInfo() ->  String? {
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                
                if let unsafeInterfaceData = unsafeInterfaceData as? Dictionary<AnyHashable, Any> {
                    return unsafeInterfaceData["SSID"] as? String
                }
            }
        }
        return nil
    }

}

