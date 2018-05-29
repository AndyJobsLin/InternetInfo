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

    private var JSONStr: String = ""
    
    @IBOutlet weak var SSIDName: UILabel!
    @IBOutlet weak var ErrorMsg: UILabel!
    @IBOutlet weak var CheckPunch: UIButton!
    
    var SSID: String? = nil
    
    
    var ErrMsg = ""
    var ResultMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ErrorMsg.text = nil
        SSID = fetchSSIDInfo()
        if(SSID == nil){
            SSIDName.text = "無Wi-Fi連線"
            SSIDName.textColor = UIColor.red
        }
        else if(SSID != "csh-staff"){
            SSIDName.textColor = UIColor.red
            SSIDName.text = SSID!
            ErrorMsg.text = "不正確的網路連線"
            CheckPunch.isEnabled = false
            return
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
        
        let WebServiceURL = "http://192.168.129.55/AppWebService/AppWebService/EmpPunchService.asmx"
        let WebServiceStr = String(format: "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><InsertIntoPunchRecord xmlns='http://tempuri.org/'><EmpNo>15432</EmpNo></InsertIntoPunchRecord></soap:Body></soap:Envelope>")
        
        let WSParser = WebServiceParser()
        WSParser.ConnentToWebService(WebServiceURL: WebServiceURL, WebServiceStr: WebServiceStr, completionHandler: {(JSONStr) -> Void in
            self.JSONStr = JSONStr
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.CheckDrInfo(JSONStr: self.JSONStr)
        }
        
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

    func CheckDrInfo(JSONStr: String){
        
        //解析Web Service 回傳資料，回傳格式為 JSON\
        let jsonString: String = "[" + JSONStr + "]"
        let jsonData: Data? = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let jsonArray: Any? = try?(JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers))
        let jsonArrayObj = jsonArray as! Array<Any>?
        for itemO in jsonArrayObj!{
            let item = itemO as! Dictionary<String, String>
            ErrMsg = (item["ErrorMsg"])!
            ResultMsg = (item["ResultMsg"])!
        }
        
        print("ErrorMsg===>\(ErrMsg)")
        print("ResultMsg===>\(ResultMsg)")
        
        if ErrMsg == "False" {
            ErrorMsg.text = ResultMsg
            return
        }
        
        
        CheckPunch.isEnabled = false
        ErrorMsg.text = ResultMsg
    }
}

