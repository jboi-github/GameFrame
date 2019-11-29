//
//  TheGameSettingsView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 23.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct TheGameSettingsView: View {
    var body: some View {
        GeometryReader {
            proxy in
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Hello, Settings!").font(.largeTitle)
                    Text("White text on blue background")
                        .font(.largeTitle)
                        .padding(20.0)
                        .border(Color.red)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct TheGameSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TheGameSettingsView()
    }
}
