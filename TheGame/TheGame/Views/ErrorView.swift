//
//  ErrorView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 04.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct ErrorView: View {
    var error: Error
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(error.localizedDescription)")
            Button(action: {
                GameFrame.inApp.clearError()
            }) {
                Image(systemName: "checkmark")
            }
            Spacer()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    private struct E : Error {
        var localizedDescription: String
    }

    static var previews: some View {
        ErrorView(error: E(localizedDescription: "Preview Showcase Error"))
    }
}

