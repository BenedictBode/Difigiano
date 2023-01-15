//
//  ContentView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI




struct LeaderBoardView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @State var rankingMethod = RankingMethod.byStickerCount
    
    enum RankingMethod {
        case byPoints
        case byStickerCount
        case byLikes
    }
    
    func sortedUsers(rankingMethod: RankingMethod, users: [Contributor], posts: [Post], likes: [String:[String]]) -> [Contributor] {
             switch rankingMethod {
             case .byPoints:
                 return users.sorted { $0.points > $1.points }
             case .byStickerCount:
                 return users.sorted { $0.posts.count > $1.posts.count }
             case .byLikes:
                 return users.sorted { $0.calculateLikes(likes: likes) > $1.calculateLikes(likes: likes) }
             }
         }
        
    var body: some View {
        VStack {
            Text(String(model.users.count) + "🥷")
                .font(.title)
            Picker(selection: $rankingMethod, label: Text("Leaderboard")) {
                Text("⭐️").tag(RankingMethod.byPoints)
                Text("🧤").tag(RankingMethod.byStickerCount)
                Text("❤️").tag(RankingMethod.byLikes)
            }.pickerStyle(SegmentedPickerStyle())
            List {
                ForEach(sortedUsers(rankingMethod: rankingMethod, users: model.users, posts: model.posts, likes: model.likes)) { user in
                    NavigationLink(destination: ProfileView(user: user))
                    {
                        HStack {
                            DifigianoAsyncImage(width: 50, imageURL: user.imageURL)
                            Text(user.name)
                                .font(.headline)
                            Spacer()
                            Group {
                                switch rankingMethod {
                                case .byPoints:
                                    Text(String(user.points) + "⭐️")
                                        .font(.system(size: 25))
                                        .bold()
                                case .byStickerCount:
                                            Text(String(user.posts.count) + "🧤")
                                        .font(.system(size: 25))
                                        .bold()
                                case .byLikes:
                                    Text(String(user.calculateLikes(likes: model.likes)) + "❤️")
                                        .font(.system(size: 25))
                                        .bold()
                                }
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut, value: rankingMethod)
            if model.currentUser?.isAdmin ?? false {
                Button() {
                    recalculatePoints()
                } label: {
                    Text("recalculate points")
                        .padding()
                }
            }
        }
    }
                                     
                                     
    
    func recalculatePoints() {
        for (i, user) in model.users.enumerated() {
            let userPoints = model.posts.filter({$0.creatorId == user.id}).map(\.points).reduce(0, +)
            if userPoints != user.points {
                var user = user
                user.points = userPoints
                model.users[i] = user
                DataStorage.persistToStorage(contributor: user)
            }
            
        }
    }
//     func sortedUsers(rankingMethod: RankingMethod, users: [Contributor], posts: [Post]) -> [(String, Contributor)] {
//         switch rankingMethod {
//         case .byPoints:
//             return users.sorted { $0.points > $1.points }.map {(String($0.points) + "⭐️", $0)}
//         case .byStickerCount:
//             /*let postsByCreatorId = Dictionary(grouping: posts, by: \.creatorId)
//             return users.sorted { (postsByCreatorId[$0.id]?.count ?? 0) > (postsByCreatorId[$1.id]?.count ?? 0) }.map {(String(postsByCreatorId[$0.id]?.count ?? 0) + "🧤", $0)}*/
//             return users.sorted { $0.points > $1.points }.map {(String($0.points) + "⭐️", $0)}
//         case .byViews:
//             return users.sorted { $0.points > $1.points }.map {(String($0.points) + "⭐️", $0)}
//         }
//     }
}
