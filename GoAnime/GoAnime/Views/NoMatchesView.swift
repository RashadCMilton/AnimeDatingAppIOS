//
//  NoMatchesView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI
struct NoMatchesView: View {
    var body: some View {
        VStack {
            Text("No matches found")
                .font(.headline)
            Text("Add more anime to your favorites")
                .foregroundColor(.secondary)
                .padding(.top, 4)
            
            Button("Refresh") {
                // Refresh logic
            }
            .padding(.top, 20)
        }
    }
}
