//
//  TestOtherView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 06.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct TestOtherView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var backToBase = false
    @State private var showingAlert = false

    var body: some View {
         VStack {
            Spacer()
            Text("Test Other View")
            Button("Go away, back to Base") {
                self.presentationMode.wrappedValue.dismiss()
            }
            Button("Show Alert") {
                withAnimation {self.showingAlert.toggle()}
            }
            NavigationLink(destination: TestYetOtherView(backToBase: $backToBase)) {
                Text("Navigate to Yet Other View")
            }
            Spacer()
        }
        .onAppear {
            if self.backToBase {self.presentationMode.wrappedValue.dismiss()}
        }
        .background(Color.yellow)
        .navigationBarHidden(true)
        .navigationBarTitle(Text("Title"))
        .navigationBarBackButtonHidden(true)
        .overlay(SubView()
            .scaleEffect(showingAlert ? 1.0 : 0.1)
            .opacity(showingAlert ? 1.0 : 0.0)
        )
    }
}

struct TestOtherView_Previews: PreviewProvider {
    static var previews: some View {
        TestOtherView()
    }
}
