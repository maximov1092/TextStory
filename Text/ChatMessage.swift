//
//  ChatMessage.swift
//  Text
//
//  Created by Admin on 14/04/2017.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class ChatMessage: NSObject {

    enum SentBy : String {
        case User = "LGChatMessageSentByUser"
        case Opponent = "LGChatMessageSentByOpponent"
    }
    
    // MARK: ObjC Compatibility
    
    /*
     ObjC can't interact w/ enums properly, so this is used for converting compatible values.
     */
    
    var color : UIColor? = nil
    
    class func SentByUserString() -> String {
        return ChatMessage.SentBy.User.rawValue
    }
    
    class func SentByOpponentString() -> String {
        return ChatMessage.SentBy.Opponent.rawValue
    }
    
    var sentByString: String {
        get {
            return sentBy.rawValue
        }
        set {
            if let sentBy = SentBy(rawValue: newValue) {
                self.sentBy = sentBy
            } else {
                print("LGChatMessage.Error : Property Set : Incompatible string set to SentByString!")
            }
        }
    }
    
    // MARK: Public Properties
    
    var sentBy: SentBy
    var content: String
    var timeStamp: TimeInterval?
    
    required init (content: String, sentBy: SentBy, timeStamp: TimeInterval? = nil){
        self.sentBy = sentBy
        self.timeStamp = timeStamp
        self.content = content
    }
    
    // MARK: ObjC Compatibility
    convenience init (content: String, sentByString: String) {
        if let sentBy = SentBy(rawValue: sentByString) {
            self.init(content: content, sentBy: sentBy, timeStamp: nil)
        } else {
            fatalError("LGChatMessage.FatalError : Initialization : Incompatible string set to SentByString!")
        }
    }
    
    convenience init (content: String, sentByString: String, timeStamp: TimeInterval) {
        if let sentBy = SentBy(rawValue: sentByString) {
            self.init(content: content, sentBy: sentBy, timeStamp: timeStamp)
        } else {
            fatalError("LGChatMessage.FatalError : Initialization : Incompatible string set to SentByString!")
        }
    }
    
}
