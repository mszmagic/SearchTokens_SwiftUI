//
//  MenuView.swift
//  SearchBarKeywordTest
//
//  Created by Shunzhe on 2022/01/30.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        List {
            NavigationLink("Movies") {
                ContentView(searchTokens: [.init(icon: UIImage(systemName: "play.rectangle.on.rectangle.fill"), text: "Movies").getTokenWithIdentifier("movies")])
            }
            NavigationLink("Music") {
                ContentView(searchTokens: [.init(icon: UIImage(systemName: "music.note"), text: "Music").getTokenWithIdentifier("music")])
            }
            NavigationLink("Documents") {
                ContentView(searchTokens: [.init(icon: UIImage(systemName: "doc"), text: "Documents").getTokenWithIdentifier("documents")])
            }
        }
        .navigationTitle("Search demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
