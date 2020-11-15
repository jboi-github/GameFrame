//
//  Navigation.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 26.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

#warning ("TODO: Bug in Swift: Too many cases in an enum will crash app")

/**
 Use one of these cases to name and parameterize a navigation item.
 
 - warning: If you wonder, why it is a two-elvel hierarchy. There's a bug in Swift with too many cases in an enum.
 */
public enum Navigation {
    public enum Generic {
        /// Open any external URL
        case Url(_ urlString: String, image: Image = Image(systemName: "link"), sound: String? = nil)
        case Action(_ action: () -> Void, image: Image, sound: String? = nil)
    }
    
    public enum Link {
        /// Start game or level.
        case Play(image: Image = Image(systemName: "play"), sound: String? = nil)
        /// Open store with given consumables and non-consumables.
        case Store(image: Image = Image(systemName: "cart"), sound: String? = nil)
        /// Open Settings page for this game.
        case Settings(image: Image = Image(systemName: "gear"), sound: String? = nil)
        /// Go back one level in store or in-level
        case Back(image: Image = Image(systemName: "chevron.left"), sound: String? = nil, prevTitle: String = "")
    }
    
    public enum Button {
        /// Return from error message
        case ErrorBack(image: Image = Image(systemName: "xmark"), sound: String? = nil)
        /// Return from showing an offer
        case OfferBack(image: Image = Image(systemName: "xmark"), sound: String? = nil)
        /// Open system preferences for this app
        case SystemSettings(image: Image = Image(systemName: "slider.horizontal.3"), sound: String? = nil)
        /// Open review page of given app id
        case Like(image: Image = Image(systemName: "hand.thumbsup"), sound: String? = nil, appId: Int)
        /// Inform app store to restore any existing purchases
        case Restore(image: Image = Image(systemName: "arrow.uturn.right"), sound: String? = nil)
        /// Start rewarded video
        case Reward(image: Image = Image(systemName: "film"), sound: String? = nil, consumableId: String, quantity: Int)
        /// Open system dialog to share with other applications
        case Share(image: Image = Image(systemName: "square.and.arrow.up"), sound: String? = nil)
        /// Open external GameCenter
        case GameCenter(image: Image = Image(systemName: "rosette"), sound: String? = nil)
    }
    
    case Generics(_ generic: Generic)
    case Links(_ link: Link)
    case Buttons(_ button: Button)
}
