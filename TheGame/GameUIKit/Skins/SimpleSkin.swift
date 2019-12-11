//
//  SkinImpl.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 06.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

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
    private let primaryColor: UIColor
    private let secondaryColor: UIColor
    private let accentColor: UIColor
    private let primaryInvertColor: UIColor
    private let secondaryInvertColor: UIColor
    private let accentInvertColor: UIColor
    
    private let buttonShadowRadius: CGFloat
    private let buttonShadowOffset: CGFloat
    private let playButtonScale: CGFloat

    private let overlayedBlurRadius: CGFloat
    private let overlayingInnerPadding: CGFloat
    private let overlayingOuterPadding: CGFloat
    private let overlayingCornerRadius: CGFloat

    public init(
        primaryColor: UIColor = UIColor.white,
        secondaryColor: UIColor = UIColor.gray,
        accentColor: UIColor = UIColor.blue,
        primaryInvertColor: UIColor = UIColor.black,
        secondaryInvertColor: UIColor = UIColor.lightGray,
        accentInvertColor: UIColor = UIColor.yellow,
        
        buttonShadowRadius: CGFloat = 5.0,
        buttonShadowOffset: CGFloat = 2.0,
        playButtonScale: CGFloat = 0.75,

        overlayedBlurRadius: CGFloat = 5.0,
        overlayingInnerPadding: CGFloat = 16,
        overlayingOuterPadding: CGFloat = 32,
        overlayingCornerRadius: CGFloat = 32
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.primaryInvertColor = primaryInvertColor
        self.secondaryInvertColor = secondaryInvertColor
        self.accentInvertColor = accentInvertColor
        self.buttonShadowRadius = buttonShadowRadius
        self.buttonShadowOffset = buttonShadowOffset
        self.playButtonScale = playButtonScale
        self.overlayedBlurRadius = overlayedBlurRadius
        self.overlayingInnerPadding = overlayingInnerPadding
        self.overlayingOuterPadding = overlayingOuterPadding
        self.overlayingCornerRadius = overlayingCornerRadius
        
        super.init()
    }
    
    override open func build(_ item: SkinItem.SkinItemText, text: Text) -> AnyView {
        switch item {
        case .StoreProductTitle, .OfferProductTitle:
            return standardText(text, font: .headline, align: .leading)
        case .StoreProductDescription, .OfferProductDescription:
            return standardText(text, font: .subheadline, align: .leading)
        case let .NavigationBarTitle(parent: parent):
            return standardText(text, font: parent == "OffLevel" ? .largeTitle : .title)
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
        case let .Main(mainItem):
            switch mainItem {
            case .Main:
                return mainBackground(view)
            default:
                return view
            }
        case let .InLevel(inLevelItem):
            switch inLevelItem {
            case let .Game(isOverlayed: isOverlayed):
                return overlayedView(view, isOverlayed: isOverlayed)
            default:
                return view
            }
        case let .Settings(settingsItem):
            switch settingsItem {
            default:
                return view
            }
        case let .Store(storeItem):
            switch storeItem {
            case let .Products(isOverlayed: isOverlayed):
                return AnyView(overlayedView(view, isOverlayed: isOverlayed).padding())
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
            case let .NavigationBar(parent: parent):
                return hide(view, hidden: parent == "InLevel")
            case let .NavigationLayer(parent: parent):
                return position(hide(view, hidden: parent == "Store"), position: parent == "InLevel" ? .topLeading : nil)
            case let .Information(parent: parent):
                return position(view, position: parent == "InLevel" ? .topTrailing : .bottom)
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
    - Navigation is set to inline.
    */
    private func standardText(_ text: Text, font: Font = .body, align: TextAlignment = .center) -> AnyView {
        let view = AnyView(text
            .foregroundColor(Color(primaryColor))
            .lineLimit(nil)
            .font(font)
            .multilineTextAlignment(align))
        
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
            .foregroundColor(isDisabled ? Color(secondaryColor) : Color(accentColor))
            .shadow(
                color: Color(secondaryColor),
                radius: buttonShadowRadius,
                x: isPressed ? -buttonShadowOffset : buttonShadowOffset,
                y: isPressed ? -buttonShadowOffset : buttonShadowOffset)
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
                        AnyView(Image(systemName: "play").resizable().scaledToFit().scaleEffect(playButtonScale)),
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
      Backgrounds are default
     */
    private func mainBackground(_ view: AnyView) -> AnyView {
        return AnyView(ZStack {
            VStack {
                Spacer()
                HStack {Spacer()}
                Spacer()
            }
            .background(Color(primaryInvertColor))
            .edgesIgnoringSafeArea(.all)
            
            view.foregroundColor(Color(primaryColor))
        })
    }
    
    /**
    - InLevel hides the back button
     */
    private func hide(_ view: AnyView, hidden: Bool) -> AnyView {
        hidden ? AnyView(EmptyView()) : view
    }
    
    /**
    OffLevel and Settings-Info on the bottom. InLevel-Info to top-center
     */
    private func position(_ view: AnyView, position: UnitPoint?) -> AnyView {
        guard let position = position else {return view}
        
        return AnyView(
            VStack {
                if ![.top, .topLeading, .topTrailing].contains(position) {Spacer()}
                HStack {
                    if ![.topLeading, .leading , .bottomLeading].contains(position) {Spacer()}
                    view
                    if ![.topTrailing, .trailing , .bottomTrailing].contains(position) {Spacer()}
                }
                if ![.bottom, .bottomLeading, .bottomTrailing].contains(position) {Spacer()}
            }
        )
    }

    /**
    - When overlayed, views are blurred
     */
    private func overlayedView(_ view: AnyView, isOverlayed: Bool) -> AnyView {
        AnyView(view.blur(radius: isOverlayed ? overlayedBlurRadius : 0.0))
    }

    /**
     - Backgroud is blurred with UltraThinMaterialDark, rounded edges as padded from the screen edges
     - Content within Overlay is extra padded
     */
    private func overlayingView(_ view: AnyView) -> AnyView {
        AnyView(view
            .padding(overlayingInnerPadding)
            .background(
                BlurView(style: .systemUltraThinMaterialLight)
                .cornerRadius(overlayingCornerRadius, antialiased: true)
            )
            .padding(overlayingOuterPadding))
    }
}
