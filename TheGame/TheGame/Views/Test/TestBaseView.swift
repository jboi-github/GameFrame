//
//  TestBaseView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 06.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI


struct TestBaseView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Test Base View")
                NavigationLink(destination: TestOtherView()) {
                    Text("Go To Other View")
                }
                Spacer()
            }
            .background(Color.gray)
            .navigationBarHidden(true)
            .navigationBarTitle(Text("Title"))
        }
    }
}

struct TestBaseView_Previews: PreviewProvider {
    static var previews: some View {
        TestBaseView()
    }
}
