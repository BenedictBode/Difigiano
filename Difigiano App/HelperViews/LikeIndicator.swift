//
//  LikeIndicator.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 10.01.23.
//

import SwiftUI

struct LikeIndicator: View {
    
    @EnvironmentObject var model: Model
    let post: Post
    
    var body: some View {
        HStack {
            Button() {
                model.likePressed(post: post)
            } label: {
                Image(systemName: heartImageName())
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                    .overlay() {
                        if let likeCount = model.likes[post.id.uuidString]?.count {
                            Text(String(likeCount))
                        }
                    }
            }
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(usersFrom(ids: model.likes[post.id.uuidString])) { liker in
                        NavigationLink(destination: ProfileView(user: liker))
                        {
                            HStack {
                                DifigianoAsyncImage(width: 40, imageURL: liker.imageURL)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func heartImageName() -> String {
        
        if let currentUser = model.currentUser {
            if let likes = model.likes[post.id.uuidString],
               likes.contains(where: { $0 == currentUser.id }) {
                return "heart.fill"
            } else if currentUser.id == post.creatorId{
                return "heart.fill"
            }
        }
           
        return "heart"
    }
    
    func usersFrom(ids: [String]?) -> [Contributor] {
        guard let ids = ids else {
            return []
        }
        return ids.compactMap { id in model.users.first(where: { user in user.id == id })}
    }
}

