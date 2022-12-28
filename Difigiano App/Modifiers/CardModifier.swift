//
//  CardModifier.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 28.12.22.
//

import SwiftUI
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 0)
    }
    
}
