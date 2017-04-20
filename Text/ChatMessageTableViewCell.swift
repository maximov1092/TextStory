//
//  ChatMessageTableViewCell.swift
//  Text
//
//  Created by Admin on 14/04/2017.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Global MessageCell Appearance Modifier
    
    struct Appearance {
        static var opponentColor = UIColor(red: 255/255, green: 92/255, blue: 142/255, alpha: 1)
        static var userColor = UIColor(red: 99/255, green: 248/255, blue: 152/255, alpha: 1)
        static var font: UIFont = UIFont.systemFont(ofSize: 17.0)
    }
    
    /*
     These methods are included for ObjC compatibility.  If using Swift, you can set the Appearance variables directly.
     */
    
    class func setAppearanceOpponentColor(_ opponentColor: UIColor) {
        Appearance.opponentColor = opponentColor
    }
    
    class func setAppearanceUserColor(_ userColor: UIColor) {
        Appearance.userColor = userColor
    }
    
    class  func setAppearanceFont(_ font: UIFont) {
        Appearance.font = font
    }
    
    // MARK: Message Bubble TextView
    
    fileprivate lazy var textView: MessageBubbleTextView = {
        let textView = MessageBubbleTextView(frame: CGRect.zero, textContainer: nil)
        self.contentView.addSubview(textView)
        return textView
    }()
    
    fileprivate class MessageBubbleTextView : UITextView {
        
        override init(frame: CGRect = CGRect.zero, textContainer: NSTextContainer? = nil) {
            super.init(frame: frame, textContainer: textContainer)
            self.font = Appearance.font
            self.isScrollEnabled = false
            self.isEditable = false
            self.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
            self.layer.cornerRadius = 15
            self.layer.borderWidth = 2.0
            
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: ImageView
    
    fileprivate lazy var opponentImageView: UIImageView = {
        let opponentImageView = UIImageView()
        opponentImageView.isHidden = true
        opponentImageView.bounds.size = CGSize(width: self.minimumHeight, height: self.minimumHeight)
        let halfWidth = opponentImageView.bounds.width / 2.0
        let halfHeight = opponentImageView.bounds.height / 2.0
        
        // Center the imageview vertically to the textView when it is singleLine
        let textViewSingleLineCenter = self.textView.textContainerInset.top + (Appearance.font.lineHeight / 2.0)
        opponentImageView.center = CGPoint(x: self.padding + halfWidth, y: textViewSingleLineCenter)
        opponentImageView.backgroundColor = UIColor.lightText
        opponentImageView.layer.rasterizationScale = UIScreen.main.scale
        opponentImageView.layer.shouldRasterize = true
        opponentImageView.layer.cornerRadius = halfHeight
        opponentImageView.layer.masksToBounds = true
        self.contentView.addSubview(opponentImageView)
        return opponentImageView
    }()
    
    // MARK: Sizing
    
    fileprivate let padding: CGFloat = 40.0
    
    fileprivate let minimumHeight: CGFloat = 30.0 // arbitrary minimum height
    
    fileprivate var size = CGSize.zero
    
    fileprivate var maxSize: CGSize {
        get {
            let maxWidth = self.bounds.width * 0.75 // Cells can take up to 3/4 of screen
            let maxHeight = CGFloat.greatestFiniteMagnitude
            return CGSize(width: maxWidth, height: maxHeight)
        }
    }
    
    // MARK: Setup Call
    
    /*!
     Use this in cellForRowAtIndexPath to setup the cell.
     */
    func setupWithMessage(_ message: ChatMessage) -> CGSize {
        textView.text = message.content
        size = textView.sizeThatFits(maxSize)
        if size.height < minimumHeight {
            size.height = minimumHeight
        }
        textView.bounds.size = size
        self.styleTextViewForSentBy(message.sentBy)
        if let color = message.color {
            self.textView.layer.borderColor = color.cgColor
        }
        return size
    }
    
    // MARK: TextBubble Styling
    
    fileprivate func styleTextViewForSentBy(_ sentBy: ChatMessage.SentBy) {
        let halfTextViewWidth = self.textView.bounds.width / 2.0
        let targetX = halfTextViewWidth + padding
        let halfTextViewHeight = self.textView.bounds.height / 2.0
        switch sentBy {
        case .Opponent:
            self.textView.center.x = targetX
            self.textView.center.y = halfTextViewHeight
            self.textView.layer.borderColor = Appearance.opponentColor.cgColor
            
            if self.opponentImageView.image != nil {
                self.opponentImageView.isHidden = false
                self.textView.center.x += self.opponentImageView.bounds.width + padding
            }
            
        case .User:
            self.opponentImageView.isHidden = true
            self.textView.center.x = self.bounds.width - targetX
            self.textView.center.y = halfTextViewHeight
            self.textView.layer.borderColor = Appearance.userColor.cgColor
        }
    }
    
    
}
