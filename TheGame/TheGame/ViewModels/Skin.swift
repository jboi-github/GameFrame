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
    // MARK: Opaque View
    public let viewOpaqueBackground = Color.black
    
    // MARK: Popup View
    public let viewPopupBackground = Color.clear
    public let viewPopupOpacity = 0.5
    public let viewPopupPadding: Double? = nil
    public let viewPopupBlur = 5.0
    
}

let skin = Skin()

struct OpaqueView: ViewModifier {
    var skin: Skin
    @State private var appeared = false
    
    func body(content: Content) -> some View {
        content
            .background(skin.viewOpaqueBackground)
            .padding()
            .onAppear {self.appeared = true}
            .onDisappear {self.appeared = false}
            .blur(radius: appeared ? 0.0 : CGFloat(skin.viewPopupBlur), opaque: false)
    }
}

struct PopupView: ViewModifier {
    var skin: Skin
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .background(skin.viewPopupBackground)
            .opacity(skin.viewPopupOpacity)
            .onAppear {self.appeared = true}
            .onDisappear {self.appeared = false}
            .blur(radius: appeared ? 0.0 : CGFloat(skin.viewPopupBlur), opaque: false)
            .padding(.all, skin.viewPopupPadding == nil ? nil : CGFloat(skin.viewPopupPadding!))
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
