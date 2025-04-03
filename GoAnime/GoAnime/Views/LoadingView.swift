//
//  LoadingView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                VStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 200)
                        .cornerRadius(8)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 20)
                        .cornerRadius(4)
                }
                .redacted(reason: .placeholder)
            }
        }
        .padding(.horizontal, 8)
    }
}
#Preview {
    LoadingView()
}
