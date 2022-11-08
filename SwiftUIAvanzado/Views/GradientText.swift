//
//  GradientText.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 08/11/22.
//

import SwiftUI

// MARK: SubViews
struct GradientText: View {
    // Properties
    var text = "Texto aquí"
    
    // View
    var body: some View {
        Text(text)
            .gradientForeground(colors:
                                    [Color("pink-gradient-1"),
                                     Color("pink-gradient-2")])
    }
}

// MARK: Extension

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self
            .overlay(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)) // Va de arriba izquierda a abajo derecha
            .mask(self)
    }
}
