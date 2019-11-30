//
//  Skin.swift
//  TheGame
//
//  Created by Juergen Boiselle on 12.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

// MARK: - Extensionsa and Views
/**
 Specialized form of `ViewModifier` for `Image`´s
 */
public protocol ImageModifier {
    associatedtype Body: View
    
    func body(image: Image) -> Self.Body
}

public extension Image {
    /**
     Specialized version of `View.modifier()` for Image fields. The modifier must be an `ImageModifier`.
     */
    func modifier<T>(_ modifier: T) -> some View where T: ImageModifier {modifier.body(image: self)}
}

/**
 Specialized form of `ViewModifier` for `Text`´s
 */
public protocol TextModifier {
    associatedtype Body: View
    
    func body(text: Text) -> Self.Body
}

public extension Text {
    /**
     Specialized version of `View.modifier()` for Text fields. The modifier must be a `TextModifier`.
     */
    func modifier<T>(_ modifier: T) -> some View where T: TextModifier {modifier.body(text: self)}
}

// MARK: - Modifier Implementations for Identity Skin
struct IdentityViewModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct IdentityImageModifier: ImageModifier {
    func body(image: Image) -> some View {image}
}

struct IdentityTextModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct PaddingModifier: ViewModifier {
    func body(content: Content) -> some View {content.padding()}
}

struct OverlayedModifier: ViewModifier {
    let isOverlayed: Bool
    
    func body(content: Content) -> some View {
        content.padding().blur(radius: isOverlayed ? 5.0 : 0.0)
    }
}

struct ButtonModifier: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

struct OverlayModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.secondary.colorInvert())
            .padding()
    }
}

struct MainBannerEmptyModifier: ViewModifier {
    func body(content: Content) -> some View {
        Text("Thank you for playing The Game")
    }
}

struct StoreProductModifier: ViewModifier {
    let id: String

    func body(content: Content) -> some View {
        content.padding(.vertical, nil)
    }
}

struct OfferModifier: ViewModifier {
    let isOverlayed: Bool
    
    func body(content: Content) -> some View {
        content
            .modifier(OverlayedModifier(isOverlayed: isOverlayed))
            .modifier(OverlayModifier())
    }
}

/**
 Define the look of your Game. Implement the protocol and override the given `extensions`as necessary.
 To implement a change in look for a particular item:
 1. Override function to get the `View/Text/ImageModifier` or `ButtonStyle`
 2. Write your own modifier and call it in the overridden function
 */
public protocol GameSkin: ObservableObject {
    associatedtype MainModifierType: ViewModifier
    associatedtype MainBannerModifierType: ViewModifier
    associatedtype MainBannerEmptyModifierType: ViewModifier
    associatedtype OffLevelModifierType: ViewModifier
    associatedtype OffLevelNavigationModifierType: ViewModifier
    associatedtype OffLevelInformationModifierType: ViewModifier
    associatedtype InLevelModifierType: ViewModifier
    associatedtype InLevelGameModifierType: ViewModifier
    associatedtype InLevelNavigationModifierType: ViewModifier
    associatedtype InLevelInformationModifierType: ViewModifier
    associatedtype InLevelGameZoneModifierType: ViewModifier
    associatedtype SettingsModifierType: ViewModifier
    associatedtype SettingsSpaceModifierType: ViewModifier
    associatedtype SettingsNavigationModifierType: ViewModifier
    associatedtype SettingsInformationModifierType: ViewModifier
    associatedtype StoreModifierType: ViewModifier
    associatedtype StoreEmptyModifierType: TextModifier
    associatedtype StoreNavigationModifierType: ViewModifier
    associatedtype StoreProductsModifierType: ViewModifier
    associatedtype StoreProductModifierType: ViewModifier
    associatedtype StoreProductButtonModifierType: ButtonStyle
    associatedtype StoreProductTitleModifierType: TextModifier
    associatedtype StoreProductDescriptionModifierType: TextModifier
    associatedtype StoreProductQuantityModifierType: TextModifier
    associatedtype StoreProductStepperModifierType: ButtonStyle
    associatedtype StoreProductCartModifierType: ImageModifier
    associatedtype StoreProductPriceModifierType: TextModifier
    associatedtype OfferModifierType: ViewModifier
    associatedtype OfferNavigationModifierType: ViewModifier
    associatedtype OfferProductsModifierType: ViewModifier
    associatedtype OfferProductModifierType: ButtonStyle
    associatedtype OfferProductTitleModifierType: TextModifier
    associatedtype OfferProductDescriptionModifierType: TextModifier
    associatedtype OfferProductCartModifierType: ImageModifier
    associatedtype OfferProductPriceModifierType: TextModifier
    associatedtype InformationItemModifierType: TextModifier
    associatedtype InformationNonConsumableModifierType: ViewModifier
    associatedtype InformationRowModifierType: ViewModifier
    associatedtype NavigationItemModifierType: ButtonStyle
    associatedtype NavigationRowModifierType: ViewModifier
    associatedtype WaitModifierType: ViewModifier
    associatedtype ErrorMessageModifierType: TextModifier
    associatedtype ErrorModifierType: ViewModifier
    
    func getMainModifier() -> MainModifierType
    func getMainBannerModifier(width: CGFloat, height: CGFloat) -> MainBannerModifierType
    func getMainBannerEmptyModifier() -> MainBannerEmptyModifierType
    func getOffLevelModifier() -> OffLevelModifierType
    func getOffLevelNavigationModifier() -> OffLevelNavigationModifierType
    func getOffLevelInformationModifier() -> OffLevelInformationModifierType
    func getInLevelModifier() -> InLevelModifierType
    func getInLevelGameModifier(isOverlayed: Bool) -> InLevelGameModifierType
    func getInLevelNavigationModifier() -> InLevelNavigationModifierType
    func getInLevelInformationModifier() -> InLevelInformationModifierType
    func getInLevelGameZoneModifier(_ selfFrame: CGRect, informationFrame: CGRect, navigationFrame: CGRect) -> InLevelGameZoneModifierType
    func getSettingsModifier() -> SettingsModifierType
    func getSettingsSpaceModifier(_ selfFrame: CGRect, informationFrame: CGRect, navigationFrame: CGRect) -> SettingsSpaceModifierType
    func getSettingsNavigationModifier() -> SettingsNavigationModifierType
    func getSettingsInformationModifier() -> SettingsInformationModifierType
    func getStoreModifier() -> StoreModifierType
    func getStoreEmptyModifier() -> StoreEmptyModifierType
    func getStoreNavigationModifier() -> StoreNavigationModifierType
    func getStoreProductsModifier(isOverlayed: Bool) -> StoreProductsModifierType
    func getStoreProductModifier(id: String) -> StoreProductModifierType
    func getStoreProductButtonModifier(id: String, isDisabled: Bool) -> StoreProductButtonModifierType
    func getStoreProductTitleModifier(id: String) -> StoreProductTitleModifierType
    func getStoreProductDescriptionModifier(id: String) -> StoreProductDescriptionModifierType
    func getStoreProductQuantityModifier(id: String) -> StoreProductQuantityModifierType
    func getStoreProductStepperModifier(id: String, isDisabled: Bool) -> StoreProductStepperModifierType
    func getStoreProductCartModifier(id: String) -> StoreProductCartModifierType
    func getStoreProductPriceModifier(id: String) -> StoreProductPriceModifierType
    func getOfferModifier(isOverlayed: Bool) -> OfferModifierType
    func getOfferNavigationModifier() -> OfferNavigationModifierType
    func getOfferProductsModifier() -> OfferProductsModifierType
    func getOfferProductModifier(id: String, isDisabled: Bool) -> OfferProductModifierType
    func getOfferProductTitleModifier(id: String) -> OfferProductTitleModifierType
    func getOfferProductDescriptionModifier(id: String) -> OfferProductDescriptionModifierType
    func getOfferProductCartModifier(id: String) -> OfferProductCartModifierType
    func getOfferProductPriceModifier(id: String) -> OfferProductPriceModifierType
    func getInformationItemModifier(parent: String, id: String) -> InformationItemModifierType
    func getInformationNonConsumableModifier(parent: String, id: String) -> InformationNonConsumableModifierType
    func getInformationRowModifier(parent: String, row: Int) -> InformationRowModifierType
    func getNavigationItemModifier(parent: String, isDisabled: Bool, item: Navigation) -> NavigationItemModifierType
    func getNavigationRowModifier(parent: String, row: Int) -> NavigationRowModifierType
    func getWaitModifier() -> WaitModifierType
    func getErrorMessageModifier() -> ErrorMessageModifierType
    func getErrorModifier() -> ErrorModifierType
}

public extension GameSkin {
       func getMainModifier() -> some ViewModifier {
           IdentityViewModifier()
      }
      func getMainBannerModifier(width: CGFloat, height: CGFloat) -> some ViewModifier {
          IdentityViewModifier()
     }
      func getMainBannerEmptyModifier() -> some ViewModifier {
          MainBannerEmptyModifier()
     }
      func getOffLevelModifier() -> some ViewModifier {
          PaddingModifier()
     }
      func getOffLevelNavigationModifier() -> some ViewModifier {
          IdentityViewModifier()
     }
      func getOffLevelInformationModifier() -> some ViewModifier {
          IdentityViewModifier()
     }
    func getInLevelModifier() -> some ViewModifier {
        IdentityViewModifier()
     }
      func getInLevelGameModifier(isOverlayed: Bool) -> some ViewModifier {
          OverlayedModifier(isOverlayed: isOverlayed)
       }
      func getInLevelNavigationModifier() -> some ViewModifier {
          IdentityViewModifier()
     }
      func getInLevelInformationModifier() -> some ViewModifier {
          IdentityViewModifier()
     }
      func getSettingsModifier() -> some ViewModifier {
          PaddingModifier()
     }
      func getSettingsNavigationModifier() -> some ViewModifier {
          IdentityViewModifier()
     }
      func getSettingsInformationModifier() -> some ViewModifier {
          IdentityViewModifier()
     }
     func getStoreModifier() -> some ViewModifier {
         IdentityViewModifier()
    }
     func getStoreEmptyModifier() -> some TextModifier {
         IdentityTextModifier()
    }
     func getStoreNavigationModifier() -> some ViewModifier {
         IdentityViewModifier()
    }
     func getStoreProductsModifier(isOverlayed: Bool) -> some ViewModifier {
         OverlayedModifier(isOverlayed: isOverlayed)
    }
      func getStoreProductModifier(id: String) -> some ViewModifier {
          StoreProductModifier(id: id)
     }
      func getStoreProductButtonModifier(id: String, isDisabled: Bool) -> some ButtonStyle {
          ButtonModifier(isDisabled: isDisabled)
     }
    func getStoreProductTitleModifier(id: String) -> some TextModifier {
        IdentityTextModifier()
    }
     func getStoreProductDescriptionModifier(id: String) -> some TextModifier {
         IdentityTextModifier()
    }
     func getStoreProductQuantityModifier(id: String) -> some TextModifier {
         IdentityTextModifier()
    }
     func getStoreProductStepperModifier(id: String, isDisabled: Bool) -> some ButtonStyle {
        ButtonModifier(isDisabled: isDisabled)
    }
     func getStoreProductCartModifier(id: String) -> some ImageModifier {
         IdentityImageModifier()
    }
     func getStoreProductPriceModifier(id: String) -> some TextModifier {
         IdentityTextModifier()
    }
      func getOfferModifier(isOverlayed: Bool) -> some ViewModifier {
        OfferModifier(isOverlayed: isOverlayed)
    }
     func getOfferNavigationModifier() -> some ViewModifier {
         IdentityViewModifier()
    }
     func getOfferProductsModifier() -> some ViewModifier {
         IdentityViewModifier()
    }
     func getOfferProductModifier(id: String, isDisabled: Bool) -> some ButtonStyle {
         ButtonModifier(isDisabled: isDisabled)
    }
     func getOfferProductTitleModifier(id: String) -> some TextModifier {
         IdentityTextModifier()
    }
     func getOfferProductDescriptionModifier(id: String) -> some TextModifier {
         IdentityTextModifier()
    }
     func getOfferProductCartModifier(id: String) -> some ImageModifier {
         IdentityImageModifier()
    }
     func getOfferProductPriceModifier(id: String) -> some TextModifier {
         IdentityTextModifier()
    }
     func getInformationItemModifier(parent: String, id: String) -> some TextModifier {
         IdentityTextModifier()
    }
      func getInformationNonConsumableModifier(parent: String, id: String) -> some ViewModifier {
          IdentityViewModifier()
     }
      func getInformationRowModifier(parent: String, row: Int) -> some ViewModifier {
          IdentityViewModifier()
     }
    func getNavigationItemModifier(parent: String, isDisabled: Bool, item: Navigation) -> some ButtonStyle {
        ButtonModifier(isDisabled: isDisabled)
    }
      func getNavigationRowModifier(parent: String, row: Int) -> some ViewModifier {
          IdentityViewModifier()
     }
     func getWaitModifier() -> some ViewModifier {
         PaddingModifier()
    }
     func getErrorMessageModifier() -> some TextModifier {
         IdentityTextModifier()
    }
     func getErrorModifier() -> some ViewModifier {
         OverlayModifier()
    }
}

// MARK: - Skin implementation for previews
struct PreviewModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

// MARK: - A Skin that delegates to standard skin implementation
class PreviewSkin: GameSkin {
    func getInLevelGameZoneModifier(_ selfFrame: CGRect, informationFrame: CGRect, navigationFrame: CGRect)
        -> some ViewModifier
    {
        PreviewModifier()
    }
    func getSettingsSpaceModifier(_ selfFrame: CGRect, informationFrame: CGRect, navigationFrame: CGRect)
        -> some ViewModifier
    {
        PreviewModifier()
    }
}

