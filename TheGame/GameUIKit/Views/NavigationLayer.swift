//
//  NavigationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct NavigationLayer<C, S>: View where C: GameConfig, S: Skin {
    let parent: String
    let items: [[Navigation]]
    let isOverlayed: Bool
    let bounds: CGRect?
    @EnvironmentObject private var skin: S
    
    init(parent: String,
         items: [[Navigation]],
         bounds: CGRect? = nil,
         isOverlayed: Bool = false)
    {
        self.parent = parent
        self.items = items
        self.bounds = bounds
        self.isOverlayed = isOverlayed
    }
    
    var body: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) {
                row in
                
                HStack {
                    ForEach(0..<self.items[row].count, id: \.self) {
                        col in
                        
                        NavigationItem<C, S>(
                            parent: self.parent,
                            item: self.items[row][col],
                            isOverlayed: self.isOverlayed,
                            bounds: self.bounds,
                            gameFrameId: "\(self.parent)-\(row)-\(col)")
                    }
                }
                .build(self.skin, .Commons(.NavigationRow(parent: self.parent, row: row)))
            }
        }
        .build(skin, .Commons(.NavigationLayer(parent: parent)))
    }
}

struct NavigationLayer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLayer<PreviewConfig, PreviewSkin>(
            parent: "Preview",
            items: [[
                .Generics(.Url("https://www.apple.com")),
                .Generics(.Url("https://www.google.com")),
                .Generics(.Url("https://www.bing.com"))
                ]])
            .environmentObject(PreviewSkin())
            .environmentObject(PreviewConfig())
    }
}
