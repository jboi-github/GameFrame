//
//  NavigationBar.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 11.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct NavigationBar<S>: View where S: Skin {
    let parent: String
    let title: String
    let item1: Navigation?
    let item2: Navigation?
    let isOverlayed: Bool
    let bounds: CGRect?
    @EnvironmentObject private var skin: S
    
    init(parent: String,
         title: String,
         item1: Navigation?,
         item2: Navigation? = nil,
         bounds: CGRect? = nil,
         isOverlayed: Bool = false)
    {
        self.parent = parent
        self.title = title
        self.item1 = item1
        self.item2 = item2
        self.bounds = bounds
        self.isOverlayed = isOverlayed
    }

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text(title).build(skin, .NavigationBarTitle(parent: parent))
                Spacer()
            }
            HStack {
                if GameUI.instance?.navigator.canGoBack() ?? false {
                    NavigationItem<S>(
                        parent: parent,
                        item: .Links(.Back()),
                        isOverlayed: isOverlayed,
                        bounds: bounds)
                }
                Spacer()
                if item1 != nil {NavigationItem<S>(parent: parent, item: item1!, isOverlayed: isOverlayed, bounds: bounds)}
                if item2 != nil {NavigationItem<S>(parent: parent, item: item2!, isOverlayed: isOverlayed, bounds: bounds)}
            }
        }
        .build(skin, .Commons(.NavigationBar(parent: parent)))
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar<PreviewSkin>(
        parent: "Preview",
        title: "Title",
        item1: .Generics(.Url("https://www.apple.com")),
        item2: .Generics(.Url("https://www.google.com")),
        isOverlayed: false)
        .environmentObject(PreviewSkin())
    }
}
