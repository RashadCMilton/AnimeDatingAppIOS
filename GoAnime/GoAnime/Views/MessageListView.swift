//
//  MessageListView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import FirebaseAuth
import SwiftUI

struct MessageListView: View {
    @StateObject private var coreDataManager = CoreDataManager()
    @State private var messages: [Message] = []
    @State private var messageContent: String = ""
    
    var matchId: String
    var currentUserId: String // identifies the current user
    
    var body: some View {
        VStack {
            // Display messages
            List {
                ForEach(messages, id: \.id) { message in
                    HStack {
                        if message.senderId == currentUserId {
                            // Sent messages (current user)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("You") // Indicate sender as "You"
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(message.content ?? "")
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                Text(message.timestamp!, style: .time)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            // Received messages (match user)
                            VStack(alignment: .leading) {
                                Text("\(message.senderId ?? "")") // Display sender's ID or name
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(message.content ?? "")
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                Text(message.timestamp!, style: .time)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // Message input field and Send button
            HStack {
                TextField("Type a message", text: $messageContent)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button("Send") {
                    sendMessage()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Chat History")
        .onAppear {
            loadMessages()
        }
    }
    
    // Updated loadMessages() method
    private func loadMessages() {
        if let currentUserId = Auth.auth().currentUser?.uid {
            messages = coreDataManager.fetchMessagesBetweenCurrentUserAndMatch(currentUserId: currentUserId, matchId: matchId)
        }
    }

    // Save the new message to Core Data
    private func sendMessage() {
        if let currentUserId = Auth.auth().currentUser?.uid {
            coreDataManager.saveMessage(
                senderId: currentUserId,
                receiverId: matchId,
                content: messageContent
            )
            messageContent = ""
            loadMessages() // Reload messages to show the new one
        }
    }
}
