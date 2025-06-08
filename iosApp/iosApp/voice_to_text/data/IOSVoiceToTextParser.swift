//
//  IOSVoiceToTextParser.swift
//  iosApp
//
//  Created by itallo alves on 08/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared
import Speech
import Combine

class IOSVoiceToTextParser: VoiceToTextParser, ObservableObject {
    
    private let _state = IOSMutableStateFlow(
        initialValue: VoiceToTextParserState(result: "", error: nil, powerRatio: 0.0, isSpeaking: false)
    )
    var state: CommonStateFlow<VoiceToTextParserState> { _state }
    
    private var micObserver = MicrophonePowerObserver()
    var micPowerRatio: Published<Double>.Publisher { micObserver.$micPowerRatio }
    private var micPowerCancellable: AnyCancellable?
    
    private var recognizer: SFSpeechRecognizer?
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    private var audioBufferRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession?
    
    func cancel() {
        // Not needed on iOS
    }
    
    func reset() {
        self.stopListening()
        _state.value = VoiceToTextParserState(result: "", error: nil, powerRatio: 0.0, isSpeaking: false)
    }
    
    func startListening(languageCode: String) {
        updateState(error: nil)
        
        let chosenLocale = Locale(identifier: languageCode)
        let supportedLocale = SFSpeechRecognizer.supportedLocales().contains(chosenLocale) ? chosenLocale : Locale(identifier: "en-US")
        self.recognizer = SFSpeechRecognizer(locale: supportedLocale)
        
        guard recognizer?.isAvailable == true else {
            updateState(error: "Speech recognizer is not available")
            return
        }
        
        audioSession = AVAudioSession.sharedInstance()
        
        requestPermissions { [weak self] in
            guard let self else { return }
            
            self.audioBufferRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let audioBufferRequest = self.audioBufferRequest else {
                return
            }
            
            self.recognitionTask = self.recognizer?.recognitionTask(with: audioBufferRequest) { result, error in
                if let result, result.isFinal {
                    self.updateState(result: result.bestTranscription.formattedString)
                    self.stopListening()
                    return
                }

                if let error {
                    self.updateState(error: error.localizedDescription)
                    self.stopListening()
                }
            }
            
            do {

                try self.audioSession?.setCategory(.playAndRecord, mode: .spokenAudio, options: .duckOthers)
                try self.audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
                
                // ⚠️ Instancie o AVAudioEngine **após ativar o AVAudioSession**
                self.audioEngine = AVAudioEngine()
                guard let inputNode = self.audioEngine?.inputNode else {
                    self.updateState(error: "Failed to get input node")
                    return
                }
                self.inputNode = inputNode
                
                // ⚠️ Agora o format está válido
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                print("SampleRate: \(recordingFormat.sampleRate), Channels: \(recordingFormat.channelCount)")
                
                guard recordingFormat.sampleRate > 0, recordingFormat.channelCount > 0 else {
                    self.updateState(error: "Invalid audio format")
                    return
                }
                
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                    self.audioBufferRequest?.append(buffer)
                }
                
                self.audioEngine?.prepare()
                try self.audioEngine?.start()
                
                self.micObserver.startObserving()
                self.updateState(isSpeaking: true)
                
                self.micPowerCancellable = self.micPowerRatio
                    .sink { [weak self] ratio in
                        self?.updateState(powerRatio: ratio)
                    }
                
            } catch {
                self.updateState(error: error.localizedDescription, isSpeaking: false)
            }
        }
    }

    
    func stopListening() {
        self.updateState(isSpeaking: false)
        
        micPowerCancellable = nil
        micObserver.release()
        
        audioBufferRequest?.endAudio()
        audioBufferRequest = nil
        
        
        audioEngine?.stop()
        
        inputNode?.removeTap(onBus: 0)
        
        try? audioSession?.setActive(false)
        audioSession = nil
    }
    
    private func requestPermissions(onGranted: @escaping () -> Void) {
        audioSession?.requestRecordPermission { [weak self] wasGranted in
            if !wasGranted {
                self?.updateState(error: "You need to grant permission to record your voice.")
                self?.stopListening()
                return
            }
            SFSpeechRecognizer.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status != .authorized {
                        self?.updateState(error: "You need to grant permission to transcribe audio.")
                        self?.stopListening()
                        return
                    }
                    onGranted()
                }
            }
        }
    }
    
    private func updateState(result: String? = nil, error: String? = nil, powerRatio: CGFloat? = nil, isSpeaking: Bool? = nil) {
        let currentState = _state.value
        _state.value = VoiceToTextParserState(
            result: result ?? currentState?.result ?? "",
            error: error ?? currentState?.error,
            powerRatio: Float(powerRatio ?? CGFloat(currentState?.powerRatio ?? 0.0)),
            isSpeaking: isSpeaking ?? currentState?.isSpeaking ?? false
        )
    }
    
}
