//
//  FriendsControllerHelper.swift
//  LBTA-14-facebook-messenger
//
//  Created by Alexander Baran on 10/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import CoreData

//class Message: NSObject {
//    var text: String?
//    var date: NSDate?
//    
//    var friend: Friend?
//}
//
//class Friend: NSObject {
//    var name: String?
//    var profileImageName: String?
//}


extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let entityNames = ["Friend", "Message"]
            do {
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                    for object in objects! {
                        context.delete(object)
                    }
                }
                
//                let messages = try context.fetch(fetchRequest) as? [Message]
//                for message in messages! {
//                    context.delete(message)
//                }

                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func setupData() {
        
        clearData()
        
        // We need to get context from AppDelegate. This is how we get the AppDelegate from a view controller.
        let delegate = UIApplication.shared.delegate as? AppDelegate
        // https://stackoverflow.com/questions/39200385/managedobjectcontext-in-swift-3
        if let context = delegate?.persistentContainer.viewContext {
            
//            let mark = Friend()
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckprofile"
            
//            let messageMark = Message()
            let messageMark = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            messageMark.friend = mark
            messageMark.text = "Hello, my name is Mark. Nice to meet you..."
            messageMark.date = NSDate()
            
            createSteveMessagesWithContext(context: context)
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "donald_profile"
            
            createMessageWithText(text: "You're fired", friend: donald, minutesAgo: 5, context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi"
            
            createMessageWithText(text: "Love, Peace, and Joy", friend: gandhi, minutesAgo: 60 * 24, context: context)
            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
            createMessageWithText(text: "Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 8 * 60 * 24, context: context)
            
            do {
                // Saving into Core Data.
                try context.save()
            } catch let error {
                print(error)
            }
            
//            messages = [messageMark, messageSteve]
        }
        
        loadData()
    }
    
    private func createSteveMessagesWithContext(context: NSManagedObjectContext) {

        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        createMessageWithText(text: "Good morning..", friend: steve, minutesAgo: 3, context: context)
        createMessageWithText(text: "Hello, how are you? Hope you are having a good morning!", friend: steve, minutesAgo: 2, context: context)
        createMessageWithText(text: "Are you interested in buying an Apple device? We have a wide variety of Apple devices that will suit your needs. Please make your purchase with us.", friend: steve, minutesAgo: 1, context: context)
        
        // Response message.
        createMessageWithText(text: "Yes, totally looking to buy and iPhone 7.", friend: steve, minutesAgo: 1, context: context, isSender: true)
        
        createMessageWithText(text: "Totally understand that you want the new iPhone 7, but you'll have to wait until September for the new release. Sorry but thats just how Apple likes to do things.", friend: steve, minutesAgo: 1, context: context)
        
        createMessageWithText(text: "Absolutely, I'll just use my gigantic iPhone 6 Plus until then!!!", friend: steve, minutesAgo: 1, context: context, isSender: true)
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            guard let friends = fetchFriends() else {
                print("no friends")
                return
            }
            
            messages = [Message]()
            
            for friend in friends {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                // Filter by getting only messages from Steve Jobs.
                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                // We will now only get the last message.
                fetchRequest.fetchLimit = 1
                do {
                    // https://stackoverflow.com/questions/36690691/casting-from-nspersistentstoreresult-to-unrelated-type-entity-always-fails
//                    messages = try context.fetch(fetchRequest) as? [Message]
                    let fetchedMessages = try context.fetch(fetchRequest) as? [Message]
                    messages?.append(contentsOf: fetchedMessages!)
                } catch let error {
                    print(error)
                }
            }
            
            messages = messages?.sorted(by: { (message1: Message, message2: Message) -> Bool in
                return message1.date!.compare(message2.date! as Date) == .orderedDescending
            })
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
                return try context.fetch(request) as? [Friend]
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}























