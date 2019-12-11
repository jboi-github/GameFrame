//
//  IdentitySkin.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 07.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

/**
 Identity skin implementation.
 
 This implementation of `Skin` does simply passthtrough all views, texts, kmages and buttons.
 No changes are made to any visible object.
 */
open class IdentitySkin: Skin {
    public init() {}
    
    open func build(_ item: SkinItem.SkinItemView, view: AnyView) -> AnyView {view}
    open func build(_ item: SkinItem.SkinItemText, text: Text) -> AnyView {AnyView(text)}
    open func build(_ item: SkinItem.SkinItemImage, image: Image) -> AnyView {AnyView(image)}
    open func build(_ item: SkinItem.SkinItemButton, label: AnyView, isPressed: Bool = false) -> AnyView {label}
}
