//
//  NavigationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

enum Navigatable {
    case Action(action: () -> Void, image: Image, disabled: Bool?)
    case ToInLevel(image: Image)
    case ToStore(image: Image, consumableIds: [String], nonConsumableIds: [String], disabled: Bool?)
}

struct NavigationArea<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    var parent: String
    var navigatables: [Navigatable]
    
    private struct NavigatableView: View {
        var skin: S
        var geometryProxy: GeometryProxy
        var parent: String
        var id: Int
        var navigatable: Navigatable
        
        var body: some View {
            let action = unpackWhenAction(navigatable: navigatable)
            let toInLevel = unpackWhenToInLevel(navigatable: navigatable)
            let toStore = unpackWhenToStore(navigatable: navigatable)
            
            let actionButton = (action != nil) ? Button(action: action!.action) {
                Spacer()
                action!.image
                Spacer()
            }
            .disabled(action!.disabled ?? false)
            .buttonStyle(self.skin.getNavigatableModifier(
                geometryProxy: self.geometryProxy, parent: parent,
                isDisabled: action!.disabled ?? false,
                id: id))
            : nil
            
            let toInLevelButton = (toInLevel != nil) ? NavigationLink(destination: InLevelView(
                skin: self.skin, geometryProxy: self.geometryProxy)) {
                Spacer()
                toInLevel!
                Spacer()
            }
            .buttonStyle(self.skin.getNavigatableModifier(geometryProxy: self.geometryProxy, parent: parent, isDisabled: false, id: id))
            : nil
            
            let toStoreButton = (toStore != nil) ? NavigationLink(destination:
                StoreView(
                    skin: self.skin,
                    geometryProxy: self.geometryProxy,
                    consumableIds: toStore!.consumableIds,
                    nonConsumableIds: toStore!.nonConsumableIds)) {
                Spacer()
                toStore!.image
                Spacer()
            }
            .disabled(toStore!.disabled ?? false)
            .buttonStyle(self.skin.getNavigatableModifier(
                geometryProxy: self.geometryProxy, parent: parent,
                isDisabled: toStore!.disabled ?? false,
                id: id))
            : nil
            
            
            return HStack {
                if actionButton != nil {
                    actionButton
                } else if toInLevelButton != nil {
                    toInLevelButton
                } else if toStoreButton != nil {
                    toStoreButton
                }
            }
        }
        
        private func unpackWhenAction(navigatable: Navigatable) -> (action: () -> Void, image: Image, disabled: Bool?)? {
            switch navigatable {
            case let .Action(action, image, disabled):
                return (action: action, image: image, disabled: disabled)
            default:
                return nil
            }
        }

        private func unpackWhenToInLevel(navigatable: Navigatable) -> Image? {
            switch navigatable {
            case let .ToInLevel(image: image):
                return image
            default:
                return nil
            }
        }
        
        private func unpackWhenToStore(navigatable: Navigatable) ->
            (image: Image, consumableIds: [String], nonConsumableIds: [String], disabled: Bool?)? {
                
            switch navigatable {
            case let .ToStore(image, consumableIds, nonConsumableIds, disabled):
                return (image, consumableIds, nonConsumableIds, disabled)
            default:
                return nil
            }
        }
    }
    
    var body: some View {
        HStack {
            ForEach(0..<navigatables.count, id: \.self) {
                id in
                
                NavigatableView(skin: self.skin, geometryProxy: self.geometryProxy, parent: self.parent, id: id, navigatable: self.navigatables[id])
            }
        }
    }
}

struct NavigationArea_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            NavigationArea(
                skin: PreviewSkin(),
                geometryProxy: $0,
                parent: "Preview",
                navigatables: [
                    .Action(action: {print("navigated1")}, image: Image(systemName: "link"), disabled: true),
                    .Action(action: {print("navigated2")}, image: Image(systemName: "rosette"), disabled: false),
                    .Action(action: {print("navigated3")}, image: Image(systemName: "gear"), disabled: nil)])
        }
    }
}
