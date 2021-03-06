//
//  MessageFilterManager.swift
//  MessageFilter
//
//  Created by zhaoyang on 2020/6/12.
//  Copyright © 2020 zhaoyang. All rights reserved.
//

import UIKit


public class MessageFilterManager: NSObject {

    public class func filterMessage(sender: String?, messageBody: String?) -> (Bool, FilterInfo?) {
        let senderInfo = sender ?? ""
        let messageBodyInfo = messageBody ?? ""
        
        let (allowArray, filterArray) = DataStoreManager.allFilterData()
        if allowArray == nil && filterArray == nil {
            return (false, nil)
        }
        
        if let allowArrayData = allowArray {
            if allowArrayData.count > 0 {
                let (match, filterInfo) = filter(sender: senderInfo, messageBody: messageBodyInfo, filterData: allowArrayData)
                if !match && filterInfo != nil {
                    return (match, filterInfo)
                }
            }
            
        }
        if let filterArrayData = filterArray {
            if filterArrayData.count > 0 {
                return filter(sender: senderInfo, messageBody: messageBodyInfo, filterData: filterArrayData)
            }
        }
        
        
//
//            var match = false
//            for filterInfo in filterArray {
//                if filterInfo.messageBody {
//                    if messageBodyInfo.count > 0 {
//                        match = filterResult(message: messageBodyInfo, regular: filterInfo.regular, rule: filterInfo.rule)
//                    }
//                } else {
//                    if senderInfo.count > 0 {
//                        match = filterResult(message: senderInfo, regular: filterInfo.regular, rule: filterInfo.rule)
//                    }
//                }
//                if match {
//                    if filterInfo.allow {
//                        return (false, filterInfo)
//                    } else {
//                        return (true, filterInfo)
//                    }
//                }
//        }
        return (false, nil)
    }
    
    public class func filter(sender: String, messageBody: String, filterData: Array<FilterInfo>) -> (Bool, FilterInfo?) {
        var match = false
        for filterInfo in filterData {
            print(filterInfo.saveMessage())
            if filterInfo.messageBody {
                if messageBody.count > 0 {
                    match = filterResult(message: messageBody, regular: filterInfo.regular, rule: filterInfo.rule)
                }
            } else {
                if sender.count > 0 {
                    match = filterResult(message: sender, regular: filterInfo.regular, rule: filterInfo.rule)
                }
            }
            if match {
                if filterInfo.allow {
                    return (false, filterInfo)
                } else {
                    return (true, filterInfo)
                }
            }
        }
        return (false, nil)
    }
    
    
    
    
    public class func getfilterMessageResult(rule: String, content: String, regular: Bool) -> [NSTextCheckingResult]? {
        if rule.count == 0 || content.count == 0 {
            return nil
        }
        do {
             let regex = try NSRegularExpression(pattern: rule, options: .caseInsensitive)
            let array = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
            return array
        } catch  {
            return nil
        }
    }
    
    
    
    private class func filterResult(message: String, regular: Bool, rule: String) -> Bool {
        if regular {
            do {
               let regex = try NSRegularExpression(pattern: rule, options: .caseInsensitive)
                let matchNum = regex.numberOfMatches(in: message, options: [], range: NSRange(location: 0, length: message.count))
                if matchNum == 0 {
                    return false
                }
                return true
            } catch  {
                return false
            }
        } else {
            if message.contains(rule) {
                return true
            } else {
                return false
            }
        }
    }
    
    
}
