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
            VStack(alignment: .center) {
                HStack{
                    Text(post.timestamp.formatted())
                        .font( .custom("UnifrakturMaguntia", size: 30))
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
                .padding()
                
                DifigianoAsyncImage(imageURL: post.imageURL)
                    .padding(.horizontal)

                if showsCreator {
                    if let creator = model.users.first(where: {post.creatorId == $0.id}) {
                        HStack {
                            NavigationLink(destination: ProfileView(user: creator,
                                                                    usersPosts: self.model.posts.filter({$0.creatorId == creator.id})).environmentObject(model))
                            {
                                HStack {
                                    DifigianoAsyncImage(width: 50, imageURL: creator.imageURL)
                                    Text("grounded by " + creator.name)
                                        .multilineTextAlignment(.leading)
                                        .font( .custom("UnifrakturMaguntia", size: 15))
                                }
                                
                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
                if showsDeleteButton {
                    Button() {
                        delete(post: post)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 25))
                            .foregroundColor(.accentColor)
                            .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(post.color)
            .foregroundColor(Color("foregroundColor"))
            .modifier(CardModifier())
            .padding(.all)
            
        }
    }
    
    func delete(post: Post) {
        if var creator = model.users.first(where: {post.creatorId == $0.id}) {
            creator.points -= post.points
            DataStorage.persistToStorage(contributor: creator)
        }
        DataStorage.deleteFromStorage(post: post)
        model.posts.removeAll(where: {$0.id == post.id})
        self.post = nil
    }
    
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 0)
    }
    
}
