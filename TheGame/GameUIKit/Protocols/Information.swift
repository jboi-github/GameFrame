//
//  Information.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 26.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/**
 Information items to be used in configuration of the game. Each reflects an information.
*/
public enum Information {
    /// Score item with given id. Current and highest value is shown.
    case Score(id: String)
    /// Achievement with given id is formatted and its current value shown
    case Achievement(id: String, format: String)
    /// Consumable with given id is shown with its current availability
    case Consumable(id: String)
    /// Non-Consumable is shown as image. Optionally an image is shown, when it is closed.
    case NonConsumable(id: String, opened: Image, closed: Image?)
}
