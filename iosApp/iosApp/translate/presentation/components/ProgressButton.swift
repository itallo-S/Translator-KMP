//
//  ProgressButton.swift
//  iosApp
//
//  Created by Itallo da Silva Alves on 04/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct ProgressButton: View {
    var text: String
    var isLoading: Bool
    var onClick: () -> Void
    
    var body: some View {
        Button(
            action: {
                if isLoading {
                    onClick()
                }
            }
        ) {
            if isLoading {
                ProgressView()
                    .animation(.easeInOut, value: isLoading)
                    .padding()
                    .background(Color.primaryColor)
                    .clipShape(Circle())
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text(text.uppercased())
                    .animation(.easeInOut, value: isLoading)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .font(.body.weight(.bold))
                    .background(Color.primaryColor)
                    .foregroundStyle(Color.onPrimary)
                    .cornerRadius(100)
            }
        }
    }
}

#Preview {
    ProgressButton(
        text: "Translate",
        isLoading: false,
        onClick: {}
    )
}
