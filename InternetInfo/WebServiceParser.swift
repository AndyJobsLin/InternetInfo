//
//  WebServiceParser.swift
//  DrPicUpload
//
//  Created by CSH.E882 on 2018/4/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

import Foundation

class WebServiceParser: NSObject, XMLParserDelegate {
    private var JSONStr: String = ""
    
    private var parserWebReturn: ((String) -> Void)?
    
    //檢查使用者身份
    func ConnentToWebService(WebServiceURL: String, WebServiceStr: String, completionHandler: ((String) -> Void)?) -> Void {
        
        self.parserWebReturn = completionHandler
        
        print("Soap Packet is \(WebServiceStr)")
        
        //連線
        var theRequest = URLRequest(url: URL(string: WebServiceURL)!)
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(WebServiceStr.count), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST" //傳遞方式
        theRequest.httpBody = WebServiceStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        print("Request is \(theRequest.allHTTPHeaderFields!)")
        
        let task = URLSession.shared.dataTask(with: theRequest, completionHandler: {(data, res, error) in
            if error != nil {
                print("ERROR : \(error!)")
                return
            }
            let ret = String(data: data!, encoding: String.Encoding.utf8)
            print(ret!)
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        })
        task.resume()
        
       
    }
    
    //開啟XML文件
    func parserDidStartDocument(_ parser: XMLParser) {
        //print("parserDidStartDocument")
    }
    
    //取得剖析XML的錯誤訊息
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        //print("parseErrorOccurred==>\(parseError)")
    }
    
    //執行剖析XML資料
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("didStartElement==>\(elementName)")
    }
    
    //取得XML資料
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("foundCharacters==>\(string)")
        JSONStr = JSONStr + string
    }
    
    //關閉剖析XML資料
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("didEndElement==>\(elementName)")
    }
    
    //關閉XML文件
    func parserDidEndDocument(_ parser: XMLParser) {
        print("parserDidEndDocument")
        print("JSONStr===>\(JSONStr)")
        
        parserWebReturn?(JSONStr)
        
    }
}

