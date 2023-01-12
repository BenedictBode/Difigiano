//
//  CustomTabifyBarStyle.swift
//  Difigiano
//
//  Created by Benedikt Geisberger on 12.01.23.
//

import SwiftUI
import Tabify

struct CustomTabifyBarStyle: BarStyle {
    @Environment(\.colorScheme) var colorScheme
    
    public func bar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        return itemsContainer()
            .padding(.horizontal, 20.0)
            .frame(height: 80)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(50.0)
            .padding(.horizontal, 25.0)
            .padding(.bottom, geometry.safeAreaInsets.bottom)
            .shadow(
                color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.10000000149011612)),
                radius:25, x:0, y:4
            )
    }
    
}
