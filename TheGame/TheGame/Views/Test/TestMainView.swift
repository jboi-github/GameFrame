//
//  TestMainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 06.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct TestMainView: View {
    var body: some View {
        VStack {
            TestBaseView()
            Text("Banner Area").background(Color.white)
        }
        .background(Color.green)
    }
}

struct TestMainView_Previews: PreviewProvider {
    static var previews: some View {
        TestMainView()
    }
}
