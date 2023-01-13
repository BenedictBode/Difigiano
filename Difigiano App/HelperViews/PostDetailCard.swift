//
//  PostDetailCard.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 11.01.23.
//

import SwiftUI

struct PostDetailCard: View {
    
    @EnvironmentObject var model: Model
    
    @Binding var post: Post?
    
    var showsDeleteButton: Bool = false
    
    var body: some View {
        if let post = self.post {
            VStack{
                VStack(spacing: 10) {
                    PostDetailView(post: post)
                    HStack {
                        if canDelete() {
                            HStack {
                                Button() {
                                    model.delete(post: post)
                                    self.post = nil
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.system(size: 15))
                                        .foregroundColor(.accentColor)
                                }
                                Spacer()
                            }
                        }
                        Spacer()
                        Button() {
                            self.post = nil
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 15))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(post.color)
            .foregroundColor(Color("foregroundColor"))
            .modifier(CardModifier())
            .padding()
        }
    }
    
    func canDelete() -> Bool {
        if let currentUser = model.currentUser {
            return currentUser.id == post?.creatorId || currentUser.isAdmin
        }
        return false
    }
}
