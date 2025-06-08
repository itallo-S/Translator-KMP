//
//  IOSVoiceToTextViewModel.swift
//  iosApp
//
//  Created by itallo alves on 08/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared
import Combine

@MainActor class IOSVoiceToTextViewModel: ObservableObject {
    private var parser: any VoiceToTextParser
    private let languageCode: String
    
    private let viewModel: VoiceToTextViewModel
    @Published var state = VoiceToTextState(powerRatios: [], spokenText: "", canRecord: false, recordError: nil, displayState: nil)
    private var handle: DisposableHandle?
    
    init(parser: VoiceToTextParser, languageCode: String) {
        self.parser = parser
        self.languageCode = languageCode
        self.viewModel = VoiceToTextViewModel(parser: parser, coroutineScope: nil)
    }
    
    func onEvent(event: VoiceToTextEvent) {
        viewModel.onEvent(event: event)
        print("Event received:", event)
        print("description ", event.description)
        if (event.description == "Reset") {
            self.viewModel.onEvent(event: VoiceToTextEvent.PermissionResult(isGranted: true, isPermanentlyDeclined: false))
        }
    }
    
    func startObserving() {
        self.viewModel.onEvent(event: VoiceToTextEvent.PermissionResult(isGranted: true, isPermanentlyDeclined: false))
        handle = viewModel.state.subscribe { [weak self] state in
            if let state {
                self?.state = state
            }
        }
    }
    
    func dispose() {
        handle?.dispose()
        onEvent(event: VoiceToTextEvent.Reset())
    }
}
