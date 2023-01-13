//
//  CustomTabifyItemStyle.swift
//  Difigiano
//
//  Created by Benedikt Geisberger on 12.01.23.
//

import SwiftUI
import Tabify

struct CustomTabifyItemStyle: ItemStyle {
    
    @ViewBuilder
    public func item(icon: String, title: String, isSelected: Bool) -> some View {
        let color: Color = isSelected ? Color("DifigianoGreen") : Color.gray
        
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("DifigianoGreen").opacity(0.15))
                    .frame(width: 55, height: 40)
            }
            
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 45.0, height: 45.0)
        }
    }
    
}
