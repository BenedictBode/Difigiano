//
//  PostInfoView.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 28.12.22.
//

import SwiftUI

struct PostInfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Image("PostExample")
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.black), lineWidth: 5)
                    )
                Text("unter 15m: zu nah (0 Punkte)")
            }
            HStack {
                Image("PostExample")
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("postClassColor1"), lineWidth: 5)
                    )
                Text("ab 15m: standard ground (1 Punkt)")
            }
            HStack {
                Image("PostExample")
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("postClassColor2"), lineWidth: 5)
                    )
                Text("ab 1km: neues Viertel (3 Punkte)")
            }
            HStack {
                Image("PostExample")
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("postClassColor3"), lineWidth: 5)
                    )
                Text("ab 50km: neue Stadt (10 Punkte)")
            }
        }
    }
}

struct PostInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PostInfoView()
    }
}
