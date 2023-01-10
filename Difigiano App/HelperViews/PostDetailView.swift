//
//  PostDetailView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 22.12.22.
//

import SwiftUI

struct PostDetailView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @Binding var post: Post?
    
    var showsDeleteButton: Bool = false
    var showsCreator: Bool = true
    
    var body: some View {
        if let post = self.post {
            VStack() {
                VStack(spacing: 10) {
                    if let creator = model.users.first(where: {post.creatorId == $0.id}) {
                        HStack {
                            NavigationLink(destination: ProfileView(user: creator))
                            {
                                HStack {
                                    DifigianoAsyncImage(width: 50, imageURL: creator.imageURL)
                                    Text(creator.name)
                                        .multilineTextAlignment(.leading)
                                }
                                
                            }
                            Spacer()
                            Button() {
                                self.post = nil
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.accentColor)
                                    .shadow(radius: 2)
                            }
                            
                        }
                    }
                    DifigianoAsyncImage(imageURL: post.imageURL)
                        .onTapGesture(count: 2) {
                            model.likePressed(post: post)
                        }
                    
                    HStack {
                        Text(post.timestamp.formatted())
                            .font(.caption)
                        Spacer()
                    }
                    
                    
                    LikeIndicator(post: post)
                    
                    
                    
                    if showsDeleteButton {
                        Button() {
                            model.delete(post: post)
                            self.post = nil
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 25))
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
    
}
