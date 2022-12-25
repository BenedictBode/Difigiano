//
//  EditableTextView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 25.12.22.
//

import SwiftUI

public struct EditableLabel: View {
    @Binding var text: String
    @State private var newValue: String = ""
    
    @State var editProcessGoing = false { didSet{ newValue = text } }
    var isEditingAllowed = true
    
    let onEditEnd: () -> Void
    
    public init(_ txt: Binding<String>, isEditingAllowed: Bool = true, onEditEnd: @escaping () -> Void) {
        _text = txt
        self.onEditEnd = onEditEnd
        self.isEditingAllowed = isEditingAllowed
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            // Text variation of View
            Text(text)
                .opacity(editProcessGoing ? 0 : 1)
            
            // TextField for edit mode of View
            TextField("", text: $newValue,
                          onEditingChanged: { _ in },
                          onCommit: { text = newValue; editProcessGoing = false; onEditEnd() } )
                .opacity(editProcessGoing ? 1 : 0)
                .multilineTextAlignment(.center)
        }
        // Enable EditMode on double tap
        .onTapGesture(count: 1, perform: { editProcessGoing = isEditingAllowed } )
    }
}
