//
//  MainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct MainView: View {
    @ObservedObject var sheets = activeSheet
    @ObservedObject var inApp = GameFrame.inApp
    
    private struct Banner: View {
        @ObservedObject var adMob = GameFrame.adMob
        
        var body: some View {
            ZStack {
                GFBannerView() // Must be called to get initial height & width
                if !adMob.bannerAvailable {Text("Thank you for playing The Game")}
            }
            .frame(width: adMob.bannerWidth, height: adMob.bannerHeight)
        }
    }
    
    var body: some View {
        VStack {
            if inApp.purchasing {
                WaitView()
            } else if inApp.error != nil {
                ErrorView(error: inApp.error!)
            } else if sheets.current == .OffLevel {
                OffLevel()
            } else if sheets.current == .InLevel {
                InLevel()
            } else if sheets.current == .Store {
                StoreView()
            } else if sheets.current == .Offer {
                AdHocOfferView()
            }
            Banner()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        GameFrame.createSharedInstanceForPreview(
            consumablesConfig: [:],
            adUnitIdBanner: nil,
            adUnitIdRewarded: nil,
            adUnitIdInterstitial: nil)
        
        return MainView()
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
