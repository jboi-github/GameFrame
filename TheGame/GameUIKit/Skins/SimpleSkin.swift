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
    
    private let smoothDuration: Double

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
        overlayingCornerRadius: CGFloat = 32,
        smoothDuration: Double = 0.5
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
        self.smoothDuration = smoothDuration
        
        super.init()
    }
    
    override open func build(_ item: SkinItem.SkinItemText, text: Text) -> AnyView {
        switch item {
        case .StoreProductTitle, .OfferProductTitle:
            return standardText(text, font: .headline, align: .leading).anyView()
        case .StoreProductDescription, .OfferProductDescription:
            return standardText(text, font: .subheadline, align: .leading).anyView()
        case let .NavigationBarTitle(parent: parent):
            return standardText(text, font: parent == "OffLevel" ? .largeTitle : .title).anyView()
        default:
            return standardText(text).anyView()
        }
    }
    
    override open func build<V>(_ item: SkinItem.SkinItemButton, label: V, isPressed: Bool = false) -> AnyView where V: View {
        switch item {
        case let .StoreProductButton(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
        case let .StoreProductStepper(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
        case let .OfferProduct(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
        case let .NavigationItem(parent: _, isDisabled: isDisabled, item: navigation):
            if isPlayButton(navigation) {
                return playButton(isDisabled: isDisabled, isPressed: isPressed).anyView()
            } else {
                return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
            }
        }
    }
    
    override open func build<V>(_ item: SkinItem.SkinItemView, view: V) -> AnyView where V: View {
        switch item {
        case let .Main(mainItem):
            switch mainItem {
            case .Main:
                return view
                    .simpleSkinBackground(primary: Color(primaryColor), primaryInvert: Color(primaryInvertColor))
                    .anyView()
            default:
                return view.anyView()
            }
        case let .OffLevel(offLevelItem):
            switch offLevelItem {
            case .Main:
                return view.simpleSkinSmooth(duration: smoothDuration).anyView()
            }
        case let .InLevel(inLevelItem):
            switch inLevelItem {
            case .Main:
                return view.simpleSkinSmooth(duration: smoothDuration).anyView()
            case let .Game(isOverlayed: isOverlayed):
                return view.simpleSkinOverlayed(isOverlayed, blurRadius: overlayedBlurRadius).anyView()
            default:
                return view.anyView()
            }
        case let .Settings(settingsItem):
            switch settingsItem {
            case .Main:
                return view.simpleSkinSmooth(duration: smoothDuration).anyView()
            default:
                return view.anyView()
            }
        case let .Store(storeItem):
            switch storeItem {
            case .Main:
                return view.simpleSkinSmooth(duration: smoothDuration).anyView()
            case let .Products(isOverlayed: isOverlayed):
                return view.simpleSkinOverlayed(isOverlayed, blurRadius: overlayedBlurRadius)
                    .padding(.horizontal)
                    .anyView()
            default:
                return view.anyView()
            }
        case let .Offer(offerItem):
            switch offerItem {
            case let .Main(isOverlayed: isOverlayed):
                return overlaying(view)
                    .simpleSkinOverlayed(isOverlayed, blurRadius: overlayedBlurRadius)
                    .simpleSkinSmooth(duration: smoothDuration)
                    .anyView()
            default:
                return view.anyView()
            }
        case let .Commons(commonsItem):
            switch commonsItem {
            case .Error, .Wait:
                return overlaying(view).anyView()
            case let .NavigationBar(parent: parent):
                return view.simpleSkinHide(parent == "InLevel").anyView()
            case let .NavigationLayer(parent: parent):
                return view.simpleSkinHide(parent == "Store")
                    .simpleSkinPosition(parent == "InLevel" ? .topLeading : nil)
                    .anyView()
            case let .Information(parent: parent):
                return view.simpleSkinPosition(parent == "InLevel" ? .topTrailing : .bottom).anyView()
            default:
                return view.anyView()
            }
        }
    }
    
    /**
    - Title and description in store and offer are aligned to leading. All other text is centered
    - Title and description in store and offer have font headline and subheadline. All other fonts are body
    - All text has primary color and the default font (When I find a way to change the font app wide, I will do so)
    - Is always defined as multiline, with unlimited number of lines
    - Navigation is set to inline.
    */
    private func standardText(_ text: Text, font: Font = .body, align: TextAlignment = .center) -> some View {
        text.simpleSkinStandard(font: font, align: align, primary: Color(primaryColor))
    }

    /**
    - All buttons have accent color and secondary color when disabled
    - Images have standard size
    - When pressed, a shodow gives the impression, that background is lowered
    */
    private func defaultButton<V>(_ label: V, isDisabled: Bool, isPressed: Bool) -> some View where V: View {
        label.simpleSkinDefaultButton(
            isDisabled: isDisabled, isPressed: isPressed,
            accentColor: Color(accentColor), secondaryColor: Color(secondaryColor),
            buttonShadowRadius: buttonShadowRadius, buttonShadowOffset: buttonShadowOffset)
    }
    
    /**
    - Play button is centered and fills the available space up to 75% with aspect ratio 1:1
    */
    private func playButton(isDisabled: Bool, isPressed: Bool) -> some View {
        Image(systemName: "play").simpleSkinPlayButton(
            isDisabled: isDisabled, isPressed: isPressed,
            playButtonScale: playButtonScale,
            accentColor: Color(accentColor), secondaryColor: Color(secondaryColor),
            buttonShadowRadius: buttonShadowRadius, buttonShadowOffset: buttonShadowOffset)
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
    - When overlayed, views are blurred
     */
    private func overlayed<V>(_ view: V, isOverlayed: Bool) -> some View where V: View {
        view.simpleSkinOverlayed(isOverlayed, blurRadius: overlayedBlurRadius)
    }

    /**
     - Backgroud is blurred with UltraThinMaterialDark, rounded edges as padded from the screen edges
     - Content within Overlay is extra padded
     */
    private func overlaying<V>(_ view: V) -> some View where V: View {
        view.simpleSkinOverlaying(
            innerPadding: overlayingInnerPadding,
            outerPadding: overlayingOuterPadding,
            cornerRadius: overlayingCornerRadius)
    }
}

// MARK: Extend view with helper functions for skins
public extension View {
    func anyView() -> AnyView {
        return AnyView(self)
    }
    
    func simpleSkinDefaultButton(
        isDisabled: Bool, isPressed: Bool,
        accentColor: Color, secondaryColor: Color,
        buttonShadowRadius: CGFloat, buttonShadowOffset: CGFloat) -> some View
    {
        self.padding()
            .foregroundColor(isDisabled ? secondaryColor : accentColor)
            .shadow(
                color: secondaryColor,
                radius: buttonShadowRadius,
                x: isPressed ? -buttonShadowOffset : buttonShadowOffset,
                y: isPressed ? -buttonShadowOffset : buttonShadowOffset)
    }
    
    func simpleSkinSmooth(duration: Double) -> some View {
        self.transition(AnyTransition.opacity.animation(Animation.easeInOut(duration: duration)))
    }
    
    func simpleSkinHide(_ hidden: Bool) -> some View {
        Group {if !hidden {self}}
    }
    
    func simpleSkinPosition(_ position: UnitPoint?) -> some View {
        Group {
            if position == nil {
                self
            } else  {
                VStack {
                    if ![.top, .topLeading, .topTrailing].contains(position!) {Spacer()}
                    HStack {
                        if ![.topLeading, .leading , .bottomLeading].contains(position!) {Spacer()}
                        self
                        if ![.topTrailing, .trailing , .bottomTrailing].contains(position!) {Spacer()}
                    }
                    if ![.bottom, .bottomLeading, .bottomTrailing].contains(position!) {Spacer()}
                }
            }
        }
    }
    
    func simpleSkinOverlayed(_ isOverlayed: Bool, blurRadius: CGFloat) -> some View {
        self.blur(radius: isOverlayed ? blurRadius : 0.0)
    }
    
    func simpleSkinOverlaying(innerPadding: CGFloat, outerPadding: CGFloat, cornerRadius: CGFloat) -> some View {
        self
        .padding(innerPadding)
        .background(
            BlurView(style: .systemUltraThinMaterialLight)
            .cornerRadius(cornerRadius, antialiased: true)
        )
        .padding(outerPadding)
    }
    
    func simpleSkinBackground(primary: Color, primaryInvert: Color) -> some View {
        ZStack {
            VStack {
                Spacer()
                HStack {Spacer()}
                Spacer()
            }
            .background(primaryInvert)
            .edgesIgnoringSafeArea(.all)
            
            self.foregroundColor(primary)
        }
    }
}

public extension Image {
    func simpleSkinPlayButton(
        isDisabled: Bool, isPressed: Bool,
        playButtonScale: CGFloat,
        accentColor: Color, secondaryColor: Color,
        buttonShadowRadius: CGFloat, buttonShadowOffset: CGFloat) -> some View
    {
        VStack {
            Spacer()
            HStack {
                Spacer()
                self.resizable().scaledToFit().scaleEffect(playButtonScale)
                    .simpleSkinDefaultButton(
                        isDisabled: isDisabled, isPressed: isPressed,
                        accentColor: accentColor, secondaryColor: secondaryColor,
                        buttonShadowRadius: buttonShadowRadius, buttonShadowOffset: buttonShadowOffset)
                Spacer()
            }
            Spacer()
        }
    }
}

public extension Text {
    func simpleSkinStandard(font: Font = .body, align: TextAlignment = .center, primary: Color) -> some View {
        let view = self
            .foregroundColor(primary)
            .lineLimit(nil)
            .font(font)
            .multilineTextAlignment(align)
        
        return Group {
            if align == .leading {
                HStack {view; Spacer()}
            } else {
                view
            }
        }
    }
}
