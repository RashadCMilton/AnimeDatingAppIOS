//
//  MessageInputView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI
import FirebaseAuth
struct MessageInputView: View {
    @State private var messageContent: String = ""
    var selectedMatch: SimpleMatchingService.UserMatch
    
    @StateObject private var coreDataManager = CoreDataManager()

    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("Type a message", text: $messageContent)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button("Send") {
                    if let currentUserId = Auth.auth().currentUser?.uid {
                        coreDataManager.saveMessage(
                            senderId: currentUserId,
                            receiverId: selectedMatch.id,
                            content: messageContent
                        )
                        messageContent = ""
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .background(Color.white)
        .shadow(radius: 5)
    }
}
