//
//  CoreDataManager.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//


import CoreData
import FirebaseAuth

class CoreDataManager: ObservableObject {
    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "GoAnimeModel") 
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error.localizedDescription)")
            }
        }
    }
    
    // Save a message to Core Data
    func saveMessage(senderId: String, receiverId: String, content: String) {
        let context = container.viewContext
        let message = Message(context: context)
        message.id = UUID()
        message.senderId = senderId
        message.receiverId = receiverId
        message.content = content
        message.timestamp = Date()
        message.isRead = false
        
        do {
            try context.save()
        } catch {
            print("Failed to save message: \(error.localizedDescription)")
        }
    }
    
    // Fetch messages for a particular conversation between two users
    func fetchMessagesBetweenCurrentUserAndMatch(currentUserId: String, matchId: String) -> [Message] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        
        // Correct predicate to match only messages between currentUserId and matchId
        fetchRequest.predicate = NSPredicate(format: "(senderId == %@ AND receiverId == %@) OR (senderId == %@ AND receiverId == %@)", currentUserId, matchId, matchId, currentUserId)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let messages = try context.fetch(fetchRequest)
            return messages
        } catch {
            print("Failed to fetch messages: \(error.localizedDescription)")
            return []
        }
    }
}
