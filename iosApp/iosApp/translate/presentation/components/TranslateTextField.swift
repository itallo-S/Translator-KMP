//
//  TranslateTextField.swift
//  iosApp
//
//  Created by Itallo da Silva Alves on 04/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers
import shared

struct TranslateTextField: View {
    @Binding var fromText: String
    let toText: String?
    let isTranslating: Bool
    let fromLanguage: UiLanguage
    let toLanguage: UiLanguage
    let onTranslateEvent: (TranslateEvent) -> Void

    var body: some View {
        if toText == "" || toText == nil || isTranslating {
            IdleTextField(
                fromText: $fromText,
                isTranslating: isTranslating,
                onTranslateEvent: onTranslateEvent
            )
            .gradientSurface()
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .animation(.easeInOut, value: isTranslating)
            .shadow(radius: 4)
        } else {
            TranslateTextField(
                fromText: fromText,
                toText: toText ?? "",
                fromLanguage: fromLanguage,
                toLanguage: toLanguage,
                onTranslateEvent: onTranslateEvent
            )
            .padding()
            .gradientSurface()
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .animation(.easeInOut, value: isTranslating)
            .shadow(radius: 4)
            .onTapGesture {
                onTranslateEvent(TranslateEvent.EditTranslation())
            }
        }
    }
}

#Preview {
    TranslateTextField(
        fromText: Binding(
            get: { "test" },
            set: { value in }
        ),
        toText: "Test",
        isTranslating: false,
        fromLanguage: UiLanguage(language: .english, imageName: "english"),
        toLanguage: UiLanguage(language: .portuguese, imageName: "portuguese"),
        onTranslateEvent: { envent in }
    )
}

extension TranslateTextField {
    fileprivate struct IdleTextField: View {
        @Binding var fromText: String
        let isTranslating: Bool
        let onTranslateEvent: (TranslateEvent) -> Void

        var body: some View {
            TextEditor(text: $fromText)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 200,
                    alignment: .topLeading
                )
                .padding()
                .foregroundStyle(Color.onSurface)
                .overlay(alignment: .bottomTrailing) {
                    ProgressButton(
                        text: "Translate",
                        isLoading: isTranslating,
                        onClick: {
                            onTranslateEvent(TranslateEvent.Translate())
                        }
                    )
                    .padding(.trailing)
                    .padding(.bottom)
                }
                .transparentScrolling()
        }
    }

    fileprivate struct TranslateTextField: View {
        let fromText: String
        let toText: String
        let fromLanguage: UiLanguage
        let toLanguage: UiLanguage
        let onTranslateEvent: (TranslateEvent) -> Void
        private let tts = TextToSpeech()

        var body: some View {
            VStack(alignment: .leading) {
                LanguageDisplay(language: fromLanguage)
                Text(fromText)
                    .foregroundColor(.onSurface)
                HStack {
                    Spacer()
                    Button(
                        action: {
                            UIPasteboard.general.setValue(
                                fromText,
                                forPasteboardType: UTType.plainText.identifier
                            )
                        }
                    ) {
                        Image(.copy)
                            .renderingMode(.template)
                            .foregroundStyle(Color.lightBlue)
                    }
                    Button(
                        action: {
                            onTranslateEvent(TranslateEvent.CloseTranslation())
                        }
                    ) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.lightBlue)
                    }
                }
                Divider()
                    .padding()
                LanguageDisplay(language: toLanguage)
                    .padding(.bottom)
                Text(toText)
                    .foregroundStyle(Color.onSurface)
                HStack {
                    Spacer()
                    Button(
                        action: {
                            UIPasteboard.general.setValue(
                                toText,
                                forPasteboardType: UTType.plainText.identifier
                            )
                        }
                    ) {
                        Image(.copy)
                            .renderingMode(.template)
                            .foregroundStyle(Color.lightBlue)
                    }
                    Button(
                        action: {
                            tts.speak(
                                text: toText,
                                language: toLanguage.language.langCode
                            )
                        }
                    ) {
                        Image(systemName: "speaker.wave.2")
                            .foregroundStyle(Color.lightBlue)
                    }
                }
            }

        }
    }
}

extension View {
    public func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
