//
//  SwapLanguageButton.swift
//  iosApp
//
//  Created by Itallo da Silva Alves on 03/06/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

struct SwapLanguageButton: View {
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Image(uiImage: UIImage(resource: .swapLanguages))
                .padding()
                .background(Color.primaryColor)
                .clipShape(Circle())
        }
    }
}

#Preview {
    SwapLanguageButton(
        onClick: {}
    )
}
