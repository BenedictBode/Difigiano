//
//  Shop.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//
import SwiftUI

struct ShopView: View {
    
    @EnvironmentObject
    private var model: Model
    
    var body: some View {
        Text("the shop")
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
            .environmentObject(Model())
    }
}
