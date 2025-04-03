//
//  SimpleMatchingView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//


//
//  SimpleMatchingView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI
import FirebaseAuth

struct SimpleMatchingView: View {
    @StateObject private var matchingService = SimpleMatchingService()
    @State private var messageContent: String = ""
    @State private var selectedMatch: SimpleMatchingService.UserMatch?
    
    // CoreDataManager instance to interact with Core Data
    @StateObject private var coreDataManager = CoreDataManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                if matchingService.isLoading {
                    ProgressView()
                } else if matchingService.matches.isEmpty {
                    NoMatchesView()
                } else {
                    MatchListView(matches: matchingService.matches)
                }
                
                // Message input and sending interface
                if let selectedMatch = selectedMatch {
                    MessageInputView(selectedMatch: selectedMatch)
                }
            }
            .navigationTitle("Anime Matches")
            .toolbar {
                Button("Refresh", action: matchingService.findMatches)
            }
            .onAppear(perform: matchingService.findMatches)
        }
    }
}



