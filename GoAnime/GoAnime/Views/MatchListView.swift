//
//  MatchListView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI
import FirebaseAuth
struct MatchListView: View {
    var matches: [SimpleMatchingService.UserMatch]
    
    var body: some View {
        List {
            ForEach(matches) { match in
                VStack(alignment: .leading) {
                    Text(match.username)
                        .font(.headline)
                    
                    Text("\(match.matchScore) anime in common")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    Text("Common anime: \(match.favoriteAnime.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Button to navigate to message list for chat history
                    NavigationLink(destination: MessageListView(
                        matchId: match.id,
                        currentUserId: Auth.auth().currentUser?.uid ?? "")) {
                        Text("View Chat History")
                            .foregroundColor(.blue)
                            .padding(.top, 5)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Your Matches") 
    }
}
