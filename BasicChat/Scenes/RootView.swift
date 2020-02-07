//
//  RootView.swift
//  BasicChat
//
//  Created by Tom Baranes on 07/02/2020.
//  Copyright © 2020 tbaranes. All rights reserved.
//

import SwiftUI

struct RootView: View {

    var body: some View {
        TabView {
            DiscussionView().tabItem {
                Image(systemName: "bubble.right.fill")
                Text("Discussion")
            }
        }.edgesIgnoringSafeArea(.top)
    }

}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
