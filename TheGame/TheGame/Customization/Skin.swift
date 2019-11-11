//
//  Skin.swift
//  TheGame
//
//  Created by Juergen Boiselle on 05.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/**
 Define the skin of an app by setting all parameters for all modifiers
 */
class Skin: NSObject {
    // MARK: First base view
    public let viewBaseBackground = Color.gray

    // MARK: Views to be navigated to
    public let viewNavigatableBackground = Color.gray
    public let navigationBarHidden = true
    public let navigationBarTitle = Text("Some Title")
    public let navigationBarBackButtonHidden = true
    
    // MARK: Overlayed View
    public let viewOverlayedBlur = 5.0
    public let viewOverlayedBackground = Color.black.opacity(0.25)
    
    // MARK: Overlay View
    public let viewOverlayBackground = Color.gray.opacity(0.9)
    public let viewOverlayPadding: CGFloat? = nil // nil = standard padding. 0.0 means "no padding"

}

fileprivate let skin = Skin()

struct BaseViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(skin.viewBaseBackground)
    }
}

struct NavigatableViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(skin.viewNavigatableBackground)
            .navigationBarHidden(skin.navigationBarHidden)
            .navigationBarTitle(skin.navigationBarTitle)
            .navigationBarBackButtonHidden(skin.navigationBarBackButtonHidden)
    }
}

/*
 How to keep dynamic but let developer design own, individual game?
 
 1. Colors
 Create a colorscheme to be refered to whne ok
 
 2. Each element
 Each element gets its own modifier. The modifier must be
 - Overwritable
 - Very flexible
 - Inherit in tree structure
 
 3. Views - Areas - Elements - Subelements
 - Mainview
    - Banner
        - Advertisement
        - Alternative
    - Content
         - WaitView
            - ActivityIndicator
         
         - ErrorView
            - ErrorMessage
            - Ok-Button
         
         - OffLevel
            - Start-Area
                - Start-Button
            - Navigation
                - Shop-Button
                - Reward-Button
                - GameCenter-Button
                - Share-Button
                - Review-Button
                - Link-Button
                - Settings-Button
            - Information
                - <<Open to Gamedesign>>
                    - Object-Value
                    - Object-Symbol

         - InLevel
             - Game-Area
                - <<Open to Gamedesign>>
             - Navigation
                 - Exit-Button
                 - Shop-Button
                 - Reward-Button
             - Information
                - <<Open to Gamedesign>>
                    - Object-Value
                    - Object-Symbol

         - StoreView
            - Consumables
                - Title
                - Description
                - Quantity
                - Price
                - Buy-Button
                - Quantity-Stepper
            - Non-Consumables
                - Title
                - Description
                - Price
                - Buy-Button
            - Navigation
                - Restore-Button
                - Exit-Button
         
         - AdHocOfferView
            - Consumables
                - Title
                - Description
                - Price
                - Buy-Button
            - Navigation
                - Reward-Button
                - Exit-Button
 4. Idea
 - Take one step toward abstraction from all elements
 - Create a class (singelton) containing:
    - Color-Schema for possible colors
    - A modifier class for each type
 
 5. Kinds of...
 - Buttons
    - Normal Button
    - Default Button
    - Destructive Button
    - Pressed/Disabled/Normal
    (size, foreground color, background image)
 - Views
    - Opaque
    (background color)
    - Popup
        - Outer background
        (background color + transparency, blur factor - actually applied on underlying view)
        - Content background
        (background color + transparency, blur factor, padding)
 - Information
    - Value
    - Metric or Symbol
 - Product
    - Title-Text
    - Description-Text
    - Price-Text
    - Quantity-Text
    - Quantity-Stepper
 
 */
