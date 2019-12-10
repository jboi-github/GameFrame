//
//  SkinImpl.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 06.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

// MARK: Simple skin implementation Modifiers
/**
- Backgroud is blurred with UltraThinMaterialDark, rounded edges as padded from the screen edges
- Content within Overlay is extra padded
*/
// MARK: Simple skin implementation Definition
/**
 The simple skin follows these rules:
 - Text:
    - All text has primary color and the default font (When I find a way to change the font app wide, I will do so)
    - Is always defined as multiline, with unlimited number of lines
    - Title and description in store and offer are aligned to leading. All other text is centered
    - Title and description in store and offer have font headline and subheadline. All other fonts are body
 - Buttons:
    - All buttons have accent color and secondary color when disabled
    - Images have standard size
    - Play button is centered and fills the available display up to 75% with aspect ratio 1:1
    - When pressed, background is grayed and gets a shadow with the impression of laying deeper
 - Views:
    - Backgrounds are default
    - Navigation is set to inline. InLevel hides the back button
    - When overlayed, views are blurred
 - Overlays:
    - Backgroud is blurred with UltraThinMaterialDark, rounded edges as padded from the screen edges
    - Content within Overlay is extra padded
*/
open class SimpleSkin: IdentitySkin {
    public override init() {super.init()}
    
    override open func build(_ item: SkinItem.SkinItemText, text: Text) -> AnyView {
        switch item {
        case .StoreProductTitle, .OfferProductTitle:
            return standardText(text, font: .headline, align: .leading)
        case .StoreProductDescription, .OfferProductDescription:
            return standardText(text, font: .subheadline, align: .leading)
        default:
            return standardText(text)
        }
    }
    
    override open func build(_ item: SkinItem.SkinItemButton, label: AnyView, isPressed: Bool = false) -> AnyView {
        switch item {
        case let .StoreProductButton(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed)
        case let .StoreProductStepper(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed)
        case let .OfferProduct(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed)
        case let .NavigationItem(parent: _, isDisabled: isDisabled, item: navigation):
            if isPlayButton(navigation) {
                return playButton(isDisabled: isDisabled, isPressed: isPressed)
            } else {
                return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed)
            }
        }
    }
    
    override open func build(_ item: SkinItem.SkinItemView, view: AnyView) -> AnyView {
        switch item {
        case let .OffLevel(offLevelItem):
            switch offLevelItem {
            case .Main:
                return navigationView(view, title: "The Game", large: true, backButton: true)
            default:
                return view
            }
        case let .InLevel(inLevelItem):
            switch inLevelItem {
            case .Main:
                return navigationView(view, title: "The Game", large: false, backButton: false)
            case let .Game(isOverlayed: isOverlayed):
                return overlayedView(view, isOverlayed: isOverlayed)
            default:
                return view
            }
        case let .Settings(settingsItem):
            switch settingsItem {
            case .Main:
                return navigationView(view, title: "Settings", large: false, backButton: true)
            default:
                return view
            }
        case let .Store(storeItem):
            switch storeItem {
            case .Main:
                return navigationView(view, title: "Store", large: false, backButton: true)
            case let .Products(isOverlayed: isOverlayed):
                return overlayedView(view, isOverlayed: isOverlayed)
            default:
                return view
            }
        case let .Offer(offerItem):
            switch offerItem {
            case let .Main(isOverlayed: isOverlayed):
                return overlayedView(overlayingView(view), isOverlayed: isOverlayed)
            default:
                return view
            }
        case let .Commons(commonsItem):
            switch commonsItem {
            case .Error, .Wait:
                return overlayingView(view)
            default:
                return view
            }
        default:
            return view
        }
    }
    
    /**
    - Title and description in store and offer are aligned to leading. All other text is centered
    - Title and description in store and offer have font headline and subheadline. All other fonts are body
    - All text has primary color and the default font (When I find a way to change the font app wide, I will do so)
    - Is always defined as multiline, with unlimited number of lines
    */
    private func standardText(_ text: Text, font: Font = .body, align: TextAlignment = .center) -> AnyView {
        let view = AnyView(text.foregroundColor(.primary).lineLimit(nil).font(font).multilineTextAlignment(align))
        
        return align == .leading ? AnyView(HStack {view; Spacer()}) : view
    }

    /**
    - All buttons have accent color and secondary color when disabled
    - Images have standard size
    - When pressed, a shodow gives the impression, that background is lowered
    */
    private func defaultButton(_ label: AnyView, isDisabled: Bool, isPressed: Bool) -> AnyView {
        AnyView(label
            .padding()
            .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
            .shadow(color: .secondary, radius: 5.0, x: isPressed ? -2.0 : 2.0, y: isPressed ? -2.0 : 2.0)
        )
    }
    
    /**
    - Play button is centered and fills the available space up to 75% with aspect ratio 1:1
    */
    private func playButton(isDisabled: Bool, isPressed: Bool) -> AnyView {
        AnyView(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    defaultButton(
                        AnyView(Image(systemName: "play").resizable().scaledToFit().scaleEffect(0.75)),
                        isDisabled: isDisabled, isPressed: isPressed)
                    Spacer()
                }
                Spacer()
            }
        )
    }
    
    private func isPlayButton(_ item: Navigation) -> Bool {
        switch item {
        case let .Links(link: link):
            switch link {
            case .Play:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    /**
    - Backgrounds are default
    - Navigation is set to inline. InLevel hides the back button
     */
    private func navigationView(_ view: AnyView, title: String, large: Bool, backButton: Bool) -> AnyView {
        AnyView(view
            .navigationBarTitle(Text(title), displayMode: large ? .large : .inline)
            .navigationBarBackButtonHidden(!backButton))
    }
    
    /**
    - When overlayed, views are blurred
     */
    private func overlayedView(_ view: AnyView, isOverlayed: Bool) -> AnyView {
        AnyView(view.blur(radius: isOverlayed ? 5.0 : 0.0))
    }

    /**
     - Backgroud is blurred with UltraThinMaterialDark, rounded edges as padded from the screen edges
     - Content within Overlay is extra padded
     */
    private func overlayingView(_ view: AnyView) -> AnyView {
        AnyView(view
            .padding(16)
            .background(
                BlurView(style: .systemUltraThinMaterialDark)
                .cornerRadius(32, antialiased: true)
            )
            .padding(32))
    }
}
