//
//  VoiceRecorderButton.swift
//  iosApp
//
//  Created by itallo alves on 08/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct VoiceRecorderButton: View {
    let displayState: DisplayState
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            ZStack {
                Circle()
                    .foregroundStyle(Color.primaryColor)
                    .padding()
                icon
                    .foregroundStyle(Color.onPrimary)
            }
        }
        .frame(maxWidth: 100.0, maxHeight: 100.0)
    }
    
    var icon: some View {
        switch displayState {
        case .speaking:
            return Image(systemName: "stop.fill")
        case .displayingResults:
            return Image(systemName: "checkmark")
        default:
            return Image(.mic)
        }
    }
}

#Preview {
    VoiceRecorderButton(
        displayState: DisplayState.waitingToTalk,
        onClick: {}
    )
}
