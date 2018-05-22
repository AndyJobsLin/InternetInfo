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

    @IBOutlet weak var Show: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Show.text = fetchSSIDInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    func currentWifiSSID() -> String {
//
//        var ssid: String = "";
//        if let interfaces = CNCopySupportedInterfaces() {
//            let interfacesArray = interfaces() as! [String]
//            if (interfacesArray.count > 0) {
//
//                let ifname = interfacesArray[0];
//                let ifdata = CNCopyCurrentNetworkInfo(ifname);
//                print("ifdata \(ifdata)")
//                //println(ifdata)
//                if(ifdata != nil)
//                {
//                    let interfaceData: Dictionary = ifdata.takeRetainedValue() as Dictionary
//                    print("interfaceData \(interfaceData)")
//                    ssid = interfaceData["SSID"] as! String
//                }
//            }
//        }
//
//        return ssid;
//    }
    
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

