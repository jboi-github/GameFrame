//
//  ContentView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 30.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello World")
            Text("Hello World")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameFrame.createSharedInstanceForPreview(
            consumablesConfig: [:],
            adUnitIdBanner: nil,
            adUnitIdRewarded: nil,
            adUnitIdInterstitial: nil)
        return ContentView()
    }
}
