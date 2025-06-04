//
//  LanguageDisplay.swift
//  iosApp
//
//  Created by Itallo da Silva Alves on 04/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct LanguageDisplay: View {
    var language: UiLanguage
    
    var body: some View {
        HStack {
            SmallLanguageIcon(language: language)
                .padding(.trailing, 5)
            Text(language.language.langName)
                .foregroundStyle(Color.lightBlue)
        }
    }
}

#Preview {
    LanguageDisplay(
        language: UiLanguage(language: .english, imageName: "english")
    )
}
