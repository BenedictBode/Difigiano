//
//  ContentView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI


enum RankingMethod {
    case byPoints
    case byStickerCount
    case byViews
}

struct LeaderBoardView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @State var sortingFunc = Contributor.compByPoints
    @State var rankingMethod = RankingMethod.byStickerCount
    
    func sortedUsers(rankingMethod: RankingMethod, users: [Contributor], posts: [Post]) -> [Contributor] {
             switch rankingMethod {
             case .byPoints:
                 return users.sorted { $0.points > $1.points }
             case .byStickerCount:
                 return users.sorted { $0.posts.count > $1.posts.count }
             case .byViews:
                 return users.sorted { $0.posts.count > $1.posts.count }
             }
         }
        
    var body: some View {
        VStack {
            Text(String(model.users.count) + "🥷")
                .font(.title)
            Picker(selection: $rankingMethod, label: Text("Leaderboard")) {
                Text("⭐️").tag(RankingMethod.byPoints)
                Text("🧤").tag(RankingMethod.byStickerCount)
                Text("👁️").tag(RankingMethod.byViews)
            }.pickerStyle(SegmentedPickerStyle())
            List {
                ForEach(sortedUsers(rankingMethod: rankingMethod, users: model.users, posts: model.posts)) { user in
                    NavigationLink(destination: ProfileView(user: user,
                                                            usersPosts: self.model.posts.filter({$0.creatorId == user.id})).environmentObject(model))
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
                                case .byViews:
                                    Text(String(user.posts.count) + "👁️")
                                        .font(.system(size: 25))
                                        .bold()
                                }
                                
                                /*Image("points")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(2)*/
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
