//
//  ExplainProfileView.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 06.01.23.
//

import SwiftUI

struct ExplainProfileView: View {
    
    @State private var showingInfo = false
    
    var body: some View {
        HStack {
            Spacer()
            Button() {
                showingInfo = true
            } label: {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .padding(20)
            }
            
        }
        .alert("Info", isPresented: $showingInfo) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text("Zum Bearbeiten von deinem Namen oder Profilbild einfach doppelt drauf tippen.")
        }
    }
}

