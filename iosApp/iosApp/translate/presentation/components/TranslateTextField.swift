//
//  TranslateTextField.swift
//  iosApp
//
//  Created by Itallo da Silva Alves on 04/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct TranslateTextField: View {
    @Binding var fromText: String
    var toText: String?
    var isTranslating: Bool
    var fromLanguage: UiLanguage
    var toLanguage: UiLanguage
    var onTranslateEvent: (TranslateEvent) -> Void

    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TranslateTextField(
        fromText: Binding(),
        isTranslating: <#T##Bool#>,
        fromLanguage: <#T##UiLanguage#>,
        toLanguage: <#T##UiLanguage#>,
        onTranslateEvent: <#T##(TranslateEvent) -> Void#>
    )
}
