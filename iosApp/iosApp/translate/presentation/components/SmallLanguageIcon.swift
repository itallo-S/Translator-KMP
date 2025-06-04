//
//  SmallLanguageIcon.swift
//  iosApp
//
//  Created by Itallo da Silva Alves on 03/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct SmallLanguageIcon: View {
    var language: UiLanguage
    
    var body: some View {
        Image(uiImage: UIImage(named: language.imageName.lowercased())!)
            .resizable()
            .frame(width: 30, height: 30)
    }
}

#Preview {
    SmallLanguageIcon(
        language: UiLanguage(language: .portuguese, imageName: "Portuguese")
    )
}
