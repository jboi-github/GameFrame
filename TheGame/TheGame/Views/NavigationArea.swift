//
//  NavigationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct NavigationArea<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    var parent: String
    var navigatables: [(action: () -> Void, image: Image, disabled: Bool?)]
    
    var body: some View {
        HStack {
            ForEach(0..<navigatables.count, id: \.self) {
                id in
                
                Button(action: self.navigatables[id].action) {
                    Spacer()
                    self.navigatables[id].image
                    Spacer()
                }
                .disabled(self.navigatables[id].disabled ?? false)
                .buttonStyle(self.skin.getNavigatableModifier(
                    geometryProxy: self.geometryProxy,
                    isDisabled: self.navigatables[id].disabled ?? false,
                    id: id))
            }
        }
    }
}

struct NavigationArea_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            NavigationArea(
                skin: SkinImpl(),
                geometryProxy: $0,
                parent: "Preview",
                navigatables: [
                (action: {print("navigated1")}, image: Image(systemName: "link"), disabled: true),
                (action: {print("navigated2")}, image: Image(systemName: "rosette"), disabled: false),
                (action: {print("navigated3")}, image: Image(systemName: "gear"), disabled: nil)])
        }
    }
}
