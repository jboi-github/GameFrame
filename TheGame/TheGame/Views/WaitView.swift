//
//  WaitView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 04.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct WaitView: View {
    @State var spin = false
    
    var body: some View {
        return VStack {
            Spacer()
            Image(systemName: "arrow.2.circlepath")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(spin ? 0 : 360))
                .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false))
                .onAppear() {self.spin.toggle()}
            Spacer()
        }
    }
}

struct WaitView_Previews: PreviewProvider {
    static var previews: some View {
        WaitView()
    }
}
