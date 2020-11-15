//
//  InformationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 08.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

private struct AchievementView<S>: View where S: Skin {
    let parent: String
    let id: String
    let format: String
    @State private var current = 0.0
    @EnvironmentObject private var skin: S
    
    init(parent: String, id: String, format: String) {
        self.parent = parent
        self.id = id
        self.format = format
        //self.current = GameFrame.coreData.getAchievement(id).current
    }
    
    var body: some View {
        Number(parent: parent, id: id, text: "\(current.format(format))")
            .build(skin, .Commons(.InformationItem(parent: parent, id: id, current: current)))
            //.onReceive(GameFrame.coreData.getAchievement(id).$current) {self.current = $0}
    }
}

private struct ScoreView<S>: View where S: Skin {
    let parent: String
    let id: String
    @State private var current = 0
    @EnvironmentObject private var skin: S
    
    init(parent: String, id: String) {
        self.parent = parent
        self.id = id
    }
    
    var body: some View {
        Number(parent: parent, id: id, text: "\(current) / \(0)")
            .build(skin, .Commons(.InformationItem(parent: parent, id: id, current: Double(current))))
            .onAppear {self.current = GameFrame.coreData.getScore(id).current}
            .onReceive(GameFrame.coreData.getScore(id).$current) {self.current = $0}
    }
}

private struct ConsumableView<S>: View where S: Skin {
    let parent: String
    let id: String
    @State private var available = 0
    @EnvironmentObject private var skin: S
    
    init(parent: String, id: String) {
        self.parent = parent
        self.id = id
    }
    
    var body: some View {
        Number(parent: parent, id: id, text: "\(available)")
            .build(skin, .Commons(.InformationItem(parent: parent, id: id, current: Double(available))))
            .onAppear {self.available = GameFrame.coreData.getConsumable(id).available}
            .onReceive(GameFrame.coreData.getConsumable(id).$available) {self.available = $0}
    }
}

private struct NonConsumableView<S>: View where S: Skin {
    let parent: String
    let id: String
    let opened: Image
    let closed: Image?
    @State private var isOpened = false
    @EnvironmentObject private var skin: S
    
    init(parent: String, id: String, opened: Image, closed: Image?) {
        self.parent = parent
        self.id = id
        self.opened = opened
        self.closed = closed
    }
    
    var body: some View {
        Group {
            if isOpened {
                opened
            } else if closed != nil {
                closed!
            }
        }
        .build(skin, .Commons(.InformationNonConsumable(parent: parent, id: id, isOpened: isOpened)))
        .onAppear {self.isOpened = GameFrame.coreData.getNonConsumable(id).isOpened}
        .onReceive(GameFrame.coreData.getNonConsumable(id).$isOpened) {self.isOpened = $0}
    }
}

private struct Item<S>: View where S: Skin {
    let parent: String
    let row: Int
    let col: Int
    let item: Information
    @EnvironmentObject private var skin: S
    
    var body: some View {
        switch item {
        case let .Achievement(id: id, format: format):
            return AchievementView<S>(parent: parent, id: id, format: format).anyView()
        case let .Score(id: id):
            return ScoreView<S>(parent: parent, id: id).anyView()
        case let .Consumable(id: id):
            return ConsumableView<S>(parent: parent, id: id).anyView()
        case let .NonConsumable(id: id, opened: opened, closed: closed):
            return NonConsumableView<S>(parent: parent, id: id, opened: opened, closed: closed).anyView()
        }
    }
}

/**
 Information items to be used in configuration of the game. Each reflects an information.
*/
struct InformationLayer<S>: View where S: Skin {
    let parent: String
    let items: [[Information]]
    @EnvironmentObject private var skin: S

    var body: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) {
                row in
                
                HStack {
                    ForEach(0..<self.items[row].count, id: \.self) {
                        col in
                        
                        Item<S>(parent: self.parent, row: row, col: col, item: self.items[row][col])
                    }
                }
                .build(self.skin, .Commons(.InformationRow(parent: self.parent, row: row)))
            }
        }
        .build(skin, .Commons(.Information(parent: parent)))
    }
}

struct InformationLayer_Previews: PreviewProvider {
    static var previews: some View {
        InformationLayer<PreviewSkin>(
            parent: "Preview",
            items: [
                [
                    .Score(id: "Points"),
                    .Consumable(id: "Bullets")
                ], [
                    .Achievement(id: "Medals", format: "%.1f"),
                    .NonConsumable(
                        id: "weaponB", opened: Image(systemName: "location"),
                        closed: Image(systemName: "location.slash")),
                    .NonConsumable(id: "weaponC", opened: Image(systemName: "location.fill"), closed: nil)
                ]
            ])
        .environmentObject(PreviewSkin())
    }
}
