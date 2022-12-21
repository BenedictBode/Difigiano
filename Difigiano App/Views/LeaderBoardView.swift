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
    
    var body: some View {
        List {
            ForEach(model.users.sorted(by: Contributor.compByPoints)) { user in
                HStack {
                    AsyncImage(url: user.imageURL,
                        content: { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(maxWidth: 50, maxHeight: 50)
                                 .clipShape(Circle())
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                    Text(user.name)
                        .font( .custom("UnifrakturMaguntia", size: 40))
                    Spacer()
                    Text(String(user.points))
                        .font( .custom("UnifrakturMaguntia", size: 40))
                }
            }
        }
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
            .environmentObject(Model())
    }
}
