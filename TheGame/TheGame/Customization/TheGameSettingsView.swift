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
    @State var image: UIImage?
    
    var body: some View {
        GeometryReader {
            proxy in
            
            VStack {
                HStack {
                    Spacer()
                    Text("Hello, Settings!").font(.largeTitle)
                    Button(action: {
                        self.image = GameFrame.instance!.getScreenhot(bounds: proxy.frame(in: .global))
                    }) {
                        Text("Get Screenshot")
                    }
                    Text("White text on blue background")
                        .font(.largeTitle)
                        .padding(20.0)
                        .border(Color.red)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                Spacer()
                if self.image == nil {
                    Text("No image")
                } else {
                    Image(uiImage: self.image!).resizable().scaledToFit().scaleEffect(0.5).border(Color.red, width: 4.0)
                }
            }
        }
    }
}

struct TheGameSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TheGameSettingsView()
    }
}
