//
//  FeedView.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 11.01.23.
//

import SwiftUI



struct FeedView: View {
    
    @EnvironmentObject var model: Model
    @State var rankingMethod = RankingMethod.byDate
    
    enum RankingMethod {
        case byDate
        case byLikes
    }
    
    func sortedPosts() -> [Post] {
        switch rankingMethod {
            
        case .byDate:
            return model.posts.sorted(by: { $0.timestamp > $1.timestamp })
        case .byLikes:
            return model.posts.sorted(by: { model.likes[$0.id.uuidString]?.count ?? 0 > model.likes[$1.id.uuidString]?.count ?? 0 })
        }
    }
    
    var body: some View {
        VStack {
            Picker(selection: $rankingMethod, label: Text("Leaderboard")) {
                Text("🗓️").tag(RankingMethod.byDate)
                Text("❤️").tag(RankingMethod.byLikes)
            }.pickerStyle(SegmentedPickerStyle())
            ScrollView {
                LazyVStack (spacing: 10) {
                    ForEach(sortedPosts()) { post in
                        VStack {
                            PostDetailView(post: post)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
