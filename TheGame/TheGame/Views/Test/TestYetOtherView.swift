//
//  TestYetOtherView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 06.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct TestYetOtherView: View {
    @Binding var backToBase: Bool
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            Text("Test Yet Other View")
            Button("One step back") {
                self.presentationMode.wrappedValue.dismiss()
            }
            Button("Back to base") {
                self.backToBase.toggle()
                self.presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
        .background(Color.red)
        .navigationBarHidden(true)
        .navigationBarTitle(Text("Title"))
        .navigationBarBackButtonHidden(true)
    }
}

struct TestYetOtherView_Previews: PreviewProvider {
    static var previews: some View {
        TestYetOtherView(backToBase: .constant(true))
    }
}
