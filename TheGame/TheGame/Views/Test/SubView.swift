//
//  SubView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 06.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct SubView: View {
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            Spacer()
            Text("Small Subview")
            Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
        .background(Color.black)
        .opacity(0.75)
        //.blur(radius: 5.0)
    }
}

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        SubView()
    }
}
