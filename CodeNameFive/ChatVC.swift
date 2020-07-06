//
//  ChatVC.swift
//  CodeNameFive
//
//  Created by Muhammad Imran on 06/07/2020.
//  Copyright © 2020 ITRID TECHNOLOGIES LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Sender : SenderType {
    var senderId: String
    
    var displayName: String
    
}

struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
}

class ChatVC: MessagesViewController, MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate, MessageCellDelegate {
    
     let currentUser = Sender(senderId: "self", displayName: "Imran")
    let otherUser = Sender(senderId: "other", displayName: "Bilal")
    var messages = [MessageType]()
    override func viewDidLoad() {
          super.viewDidLoad()
        
               if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
                 layout.setMessageIncomingAvatarSize(.zero)
                 layout.setMessageOutgoingAvatarSize(.zero)
               }
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
         messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
         messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
         messages.append(Message(sender: otherUser, messageId: "4", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
         messages.append(Message(sender: currentUser, messageId: "5", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
         messages.append(Message(sender: otherUser, messageId: "6", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
         messages.append(Message(sender: otherUser, messageId: "7", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
         messages.append(Message(sender: currentUser, messageId: "8", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello, I’m here can you open the door for me please?")))
        
      }
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        return .bubbleTail(.bottomRight, .curved)

    }
       func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0, green: 0.8465872407, blue: 0.7545004487, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1.0)
       }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
        
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func configureMessageCollectionView() {

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self

        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false

//        messagesCollectionView.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

             return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
         }

//         func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//             let name = message.sender.displayName
//             return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//         }

         func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            // let df = DateFormatter()
//             df.dateFormat = "hh:mm"
//             let dateString = df.string(from: message.sentDate)
//            return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
             return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),NSAttributedString.Key.foregroundColor :UIColor.darkGray ])
            
         }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            
        return NSAttributedString(string: "read", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),NSAttributedString.Key.foregroundColor :UIColor.darkGray ])
           }
    
    
    
    
    

}
extension ChatVC {

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")

    }

    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }

    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}




