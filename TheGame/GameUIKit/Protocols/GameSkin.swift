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
    func modifier<T>(_ modifier: T) -> some View where T: TextModifier {modifier.body(text: self)}
}

// MARK: - Modifier Implementations for Identity Skin
struct MainModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

struct MainBannerModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    
    func body(content: Content) -> some View {content}
}

struct MainBannerEmptyModifier: ViewModifier {
    func body(content: Content) -> some View {
        Text("Thank you for playing The Game")
    }
}

struct OffLevelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .padding()
    }
}

struct OffLevelNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct OffLevelInformationModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct InLevelModifier: ViewModifier {
    let isOverlayed: Bool
    
    func body(content: Content) -> some View {
        content.padding().blur(radius: isOverlayed ? 5.0 : 0.0)
    }
}

struct InLevelNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct InLevelInformationModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct InLevelGameZoneModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct StoreModifier: ViewModifier {
    let isOverlayed: Bool
    
    func body(content: Content) -> some View {
        content.padding().blur(radius: isOverlayed ? 5.0 : 0.0)
    }
}

struct StoreEmptyModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct StoreNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct StoreConsumablesModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct StoreConsumableModifier: ViewModifier {
    var id: String

    func body(content: Content) -> some View {
        content.padding(.vertical, nil)
    }
}

struct StoreConsumableButtonModifier: ButtonStyle {
    var isDisabled: Bool
    var id: String
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let proxy = (GameUI.instance.geometryProxy)!
        
        return configuration.label
            .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
            .frame(width: proxy.size.width * 1.0/4.0)
    }
}

struct StoreConsumableTitleModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct StoreConsumableDescriptionModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct StoreConsumableQuantityModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct StoreConsumableStepperModifier: ButtonStyle {
    var isDisabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        let proxy = GameUI.instance.geometryProxy!
        
        return configuration.label
            .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
            .frame(width: proxy.size.width * 1.0/3.0)
    }
}

struct StoreConsumableCartModifier: ImageModifier {
    func body(image: Image) -> some View {image}
}

struct StoreConsumablePriceModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct StoreNonConsumablesModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct StoreNonConsumableModifier: ViewModifier {
    var id: String

    func body(content: Content) -> some View {
        content.padding(.vertical, nil)
    }
}

struct StoreNonConsumableButtonModifier: ButtonStyle {
    var isDisabled: Bool
    var id: String

   func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

struct StoreNonConsumableTitleModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct StoreNonConsumableDescriptionModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct StoreNonConsumableCartModifier: ImageModifier {
    func body(image: Image) -> some View {image}
}

struct StoreNonConsumablePriceModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct OfferModifier: ViewModifier {
    let isOverlayed: Bool
    
    func body(content: Content) -> some View {
        content
        .padding()
        .background(Color.secondary.colorInvert())
        .blur(radius: isOverlayed ? 5.0 : 0.0)
    }
}

struct OfferNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct OfferProductsModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

struct OfferProductModifier: ButtonStyle {
    var isDisabled: Bool
    var id: String

   func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

struct OfferProductTitleModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct OfferProductDescriptionModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct OfferProductCartModifier: ImageModifier {
    func body(image: Image) -> some View {image}
}

struct OfferProductPriceModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct InformationAchievementModifier: TextModifier {
    var parent: String
    var id: String

    func body(text: Text) -> some View {text}
}

struct InformationScoreModifier: TextModifier {
    var parent: String
    var id: String

    func body(text: Text) -> some View {text}
}

struct InformationConsumableModifier: TextModifier {
    var parent: String
    var id: String

    func body(text: Text) -> some View {text}
}

struct InformationNonConsumableModifier: ViewModifier {
    var parent: String
    var id: String

    func body(content: Content) -> some View {content}
}

struct InformationRowModifier: ViewModifier {
    var parent: String
    var row: Int

    func body(content: Content) -> some View {content}
}

struct NavigationItemModifier: ButtonStyle {
    var parent: String
    var isDisabled: Bool
    var row: Int
    var col: Int

    func makeBody(configuration: Self.Configuration) -> some View {
        VStack {
            if parent == "OffLevel" && row == 0 && col == 0 {
                Spacer()
                Image(systemName: "play.circle")
                    .resizable().scaledToFit()
                    .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
                Spacer()
            } else {
                configuration.label
                    .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
                    .padding()
            }
        }
    }
}

struct NavigationRowModifier: ViewModifier {
    var parent: String
    var row: Int

    func body(content: Content) -> some View {content}
}

struct WaitWithErrorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.secondary.colorInvert())
    }
}

struct WaitModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .padding()
    }
}

struct ErrorMessageModifier: TextModifier {
    func body(text: Text) -> some View {text}
}

struct ErrorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.secondary.colorInvert())
    }
}

public protocol GameSkin: ObservableObject {
    associatedtype MainModifierType: ViewModifier
    associatedtype MainBannerModifierType: ViewModifier
    associatedtype MainBannerEmptyModifierType: ViewModifier
    associatedtype OffLevelModifierType: ViewModifier
    associatedtype OffLevelNavigationModifierType: ViewModifier
    associatedtype OffLevelInformationModifierType: ViewModifier
    associatedtype InLevelModifierType: ViewModifier
    associatedtype InLevelNavigationModifierType: ViewModifier
    associatedtype InLevelInformationModifierType: ViewModifier
    associatedtype InLevelGameZoneModifierType: ViewModifier
    associatedtype StoreModifierType: ViewModifier
    associatedtype StoreEmptyModifierType: TextModifier
    associatedtype StoreNavigationModifierType: ViewModifier
    associatedtype StoreConsumablesModifierType: ViewModifier
    associatedtype StoreConsumableModifierType: ViewModifier
    associatedtype StoreConsumableButtonModifierType: ButtonStyle
    associatedtype StoreConsumableTitleModifierType: TextModifier
    associatedtype StoreConsumableDescriptionModifierType: TextModifier
    associatedtype StoreConsumableQuantityModifierType: TextModifier
    associatedtype StoreConsumableStepperModifierType: ButtonStyle
    associatedtype StoreConsumableCartModifierType: ImageModifier
    associatedtype StoreConsumablePriceModifierType: TextModifier
    associatedtype StoreNonConsumablesModifierType: ViewModifier
    associatedtype StoreNonConsumableModifierType: ViewModifier
    associatedtype StoreNonConsumableButtonModifierType: ButtonStyle
    associatedtype StoreNonConsumableTitleModifierType: TextModifier
    associatedtype StoreNonConsumableDescriptionModifierType: TextModifier
    associatedtype StoreNonConsumableCartModifierType: ImageModifier
    associatedtype StoreNonConsumablePriceModifierType: TextModifier
    associatedtype OfferModifierType: ViewModifier
    associatedtype OfferNavigationModifierType: ViewModifier
    associatedtype OfferProductsModifierType: ViewModifier
    associatedtype OfferProductModifierType: ButtonStyle
    associatedtype OfferProductTitleModifierType: TextModifier
    associatedtype OfferProductDescriptionModifierType: TextModifier
    associatedtype OfferProductCartModifierType: ImageModifier
    associatedtype OfferProductPriceModifierType: TextModifier
    associatedtype InformationAchievementModifierType: TextModifier
    associatedtype InformationScoreModifierType: TextModifier
    associatedtype InformationConsumableModifierType: TextModifier
    associatedtype InformationNonConsumableModifierType: ViewModifier
    associatedtype InformationRowModifierType: ViewModifier
    associatedtype NavigationItemModifierType: ButtonStyle
    associatedtype NavigationRowModifierType: ViewModifier
    associatedtype WaitWithErrorModifierType: ViewModifier
    associatedtype WaitModifierType: ViewModifier
    associatedtype ErrorMessageModifierType: TextModifier
    associatedtype ErrorModifierType: ViewModifier
    
    func getMainModifier() -> MainModifierType
    func getMainBannerModifier(width: CGFloat, height: CGFloat) -> MainBannerModifierType
    func getMainBannerEmptyModifier() -> MainBannerEmptyModifierType
    func getOffLevelModifier() -> OffLevelModifierType
    func getOffLevelNavigationModifier() -> OffLevelNavigationModifierType
    func getOffLevelInformationModifier() -> OffLevelInformationModifierType
    func getInLevelModifier(isOverlayed: Bool) -> InLevelModifierType
    func getInLevelNavigationModifier() -> InLevelNavigationModifierType
    func getInLevelInformationModifier() -> InLevelInformationModifierType
    func getInLevelGameZoneModifier() -> InLevelGameZoneModifierType
    func getStoreModifier(isOverlayed: Bool) -> StoreModifierType
    func getStoreEmptyModifier() -> StoreEmptyModifierType
    func getStoreNavigationModifier() -> StoreNavigationModifierType
    func getStoreConsumablesModifier() -> StoreConsumablesModifierType
    func getStoreConsumableModifier(id: String) -> StoreConsumableModifierType
    func getStoreConsumableButtonModifier(isDisabled: Bool, id: String) -> StoreConsumableButtonModifierType
    func getStoreConsumableTitleModifier() -> StoreConsumableTitleModifierType
    func getStoreConsumableDescriptionModifier() -> StoreConsumableDescriptionModifierType
    func getStoreConsumableQuantityModifier() -> StoreConsumableQuantityModifierType
    func getStoreConsumableStepperModifier(isDisabled: Bool) -> StoreConsumableStepperModifierType
    func getStoreConsumableCartModifier() -> StoreConsumableCartModifierType
    func getStoreConsumablePriceModifier() -> StoreConsumablePriceModifierType
    func getStoreNonConsumablesModifier() -> StoreNonConsumablesModifierType
    func getStoreNonConsumableModifier(id: String) -> StoreNonConsumableModifierType
    func getStoreNonConsumableButtonModifier(isDisabled: Bool, id: String) -> StoreNonConsumableButtonModifierType
    func getStoreNonConsumableTitleModifier() -> StoreNonConsumableTitleModifierType
    func getStoreNonConsumableDescriptionModifier() -> StoreNonConsumableDescriptionModifierType
    func getStoreNonConsumableCartModifier() -> StoreNonConsumableCartModifierType
    func getStoreNonConsumablePriceModifier() -> StoreNonConsumablePriceModifierType
    func getOfferModifier(isOverlayed: Bool) -> OfferModifierType
    func getOfferNavigationModifier() -> OfferNavigationModifierType
    func getOfferProductsModifier() -> OfferProductsModifierType
    func getOfferProductModifier(isDisabled: Bool, id: String) -> OfferProductModifierType
    func getOfferProductTitleModifier() -> OfferProductTitleModifierType
    func getOfferProductDescriptionModifier() -> OfferProductDescriptionModifierType
    func getOfferProductCartModifier() -> OfferProductCartModifierType
    func getOfferProductPriceModifier() -> OfferProductPriceModifierType
    func getInformationAchievementModifier(parent: String, id: String) -> InformationAchievementModifierType
    func getInformationScoreModifier(parent: String, id: String) -> InformationScoreModifierType
    func getInformationConsumableModifier(parent: String, id: String) -> InformationConsumableModifierType
    func getInformationNonConsumableModifier(parent: String, id: String) -> InformationNonConsumableModifierType
    func getInformationRowModifier(parent: String, row: Int) -> InformationRowModifierType
    func getNavigationItemModifier(parent: String, isDisabled: Bool, row: Int, col: Int) -> NavigationItemModifierType
    func getNavigationRowModifier(parent: String, row: Int) -> NavigationRowModifierType
    func getWaitWithErrorModifier() -> WaitWithErrorModifierType
    func getWaitModifier() -> WaitModifierType
    func getErrorMessageModifier() -> ErrorMessageModifierType
    func getErrorModifier() -> ErrorModifierType
}

public extension GameSkin {
     func getMainModifier() -> some ViewModifier {
         return MainModifier()
    }
      func getMainBannerModifier(width: CGFloat, height: CGFloat) -> some ViewModifier {
          MainBannerModifier(width: width, height: height)
     }
      func getMainBannerEmptyModifier() -> some ViewModifier {
          MainBannerEmptyModifier()
     }
      func getOffLevelModifier() -> some ViewModifier {
          OffLevelModifier()
     }
      func getOffLevelNavigationModifier() -> some ViewModifier {
          OffLevelNavigationModifier()
     }
      func getOffLevelInformationModifier() -> some ViewModifier {
          OffLevelInformationModifier()
     }
    func getInLevelModifier(isOverlayed: Bool) -> some ViewModifier {
        InLevelModifier(isOverlayed: isOverlayed)
     }
      func getInLevelNavigationModifier() -> some ViewModifier {
          InLevelNavigationModifier()
     }
      func getInLevelInformationModifier() -> some ViewModifier {
          InLevelInformationModifier()
     }
     func getStoreModifier(isOverlayed: Bool) -> some ViewModifier {
         StoreModifier(isOverlayed: isOverlayed)
    }
     func getStoreEmptyModifier() -> some TextModifier {
         StoreEmptyModifier()
    }
     func getStoreNavigationModifier() -> some ViewModifier {
         StoreNavigationModifier()
    }
     func getStoreConsumablesModifier() -> some ViewModifier {
         StoreConsumablesModifier()
    }
      func getStoreConsumableModifier(id: String) -> some ViewModifier {
          StoreConsumableModifier(id: id)
     }
      func getStoreConsumableButtonModifier(isDisabled: Bool, id: String) -> some ButtonStyle {
          StoreConsumableButtonModifier(isDisabled: isDisabled, id: id)
     }
     func getStoreConsumableTitleModifier() -> some TextModifier {
         StoreConsumableTitleModifier()
    }
     func getStoreConsumableDescriptionModifier() -> some TextModifier {
         StoreConsumableDescriptionModifier()
    }
     func getStoreConsumableQuantityModifier() -> some TextModifier {
         StoreConsumableQuantityModifier()
    }
     func getStoreConsumableStepperModifier(isDisabled: Bool) -> some ButtonStyle {
         StoreConsumableStepperModifier(isDisabled: isDisabled)
    }
     func getStoreConsumableCartModifier() -> some ImageModifier {
         StoreConsumableCartModifier()
    }
     func getStoreConsumablePriceModifier() -> some TextModifier {
         StoreConsumablePriceModifier()
    }
      func getStoreNonConsumablesModifier() -> some ViewModifier {
          StoreNonConsumablesModifier()
     }
     func getStoreNonConsumableModifier(id: String) -> some ViewModifier {
         StoreNonConsumableModifier(id: id)
     }
     func getStoreNonConsumableButtonModifier(isDisabled: Bool, id: String) -> some ButtonStyle {
         StoreNonConsumableButtonModifier(isDisabled: isDisabled, id: id)
    }
     func getStoreNonConsumableTitleModifier() -> some TextModifier {
         StoreNonConsumableTitleModifier()
    }
     func getStoreNonConsumableDescriptionModifier() -> some TextModifier {
         StoreNonConsumableDescriptionModifier()
    }
     func getStoreNonConsumableCartModifier() -> some ImageModifier {
         StoreNonConsumableCartModifier()
    }
     func getStoreNonConsumablePriceModifier() -> some TextModifier {
         StoreNonConsumablePriceModifier()
    }
    func getOfferModifier(isOverlayed: Bool) -> some ViewModifier {
        OfferModifier(isOverlayed: isOverlayed)
    }
     func getOfferNavigationModifier() -> some ViewModifier {
         OfferNavigationModifier()
    }
     func getOfferProductsModifier() -> some ViewModifier {
         OfferProductsModifier()
    }
     func getOfferProductModifier(isDisabled: Bool, id: String) -> some ButtonStyle {
         OfferProductModifier(isDisabled: isDisabled, id: id)
    }
     func getOfferProductTitleModifier() -> some TextModifier {
         OfferProductTitleModifier()
    }
     func getOfferProductDescriptionModifier() -> some TextModifier {
         OfferProductDescriptionModifier()
    }
     func getOfferProductCartModifier() -> some ImageModifier {
         OfferProductCartModifier()
    }
     func getOfferProductPriceModifier() -> some TextModifier {
         OfferProductPriceModifier()
    }
     func getInformationAchievementModifier(parent: String, id: String) -> some TextModifier {
         InformationAchievementModifier(parent: parent, id: id)
    }
     func getInformationScoreModifier(parent: String, id: String) -> some TextModifier {
         InformationScoreModifier(parent: parent, id: id)
    }
     func getInformationConsumableModifier(parent: String, id: String) -> some TextModifier {
         InformationConsumableModifier(parent: parent, id: id)
    }
      func getInformationNonConsumableModifier(parent: String, id: String) -> some ViewModifier {
          InformationNonConsumableModifier(parent: parent, id: id)
     }
      func getInformationRowModifier(parent: String, row: Int) -> some ViewModifier {
          InformationRowModifier(parent: parent, row: row)
     }
    func getNavigationItemModifier(parent: String, isDisabled: Bool, row: Int, col: Int) -> some ButtonStyle {
         NavigationItemModifier(parent: parent, isDisabled: isDisabled, row: row, col: col)
    }
      func getNavigationRowModifier(parent: String, row: Int) -> some ViewModifier {
          NavigationRowModifier(parent: parent, row: row)
     }
     func getWaitWithErrorModifier() -> some ViewModifier {
         WaitWithErrorModifier()
    }
     func getWaitModifier() -> some ViewModifier {
         WaitModifier()
    }
     func getErrorMessageModifier() -> some TextModifier {
         ErrorMessageModifier()
    }
     func getErrorModifier() -> some ViewModifier {
         ErrorModifier()
    }
}

// MARK: - Skin implementation for previews
struct PreviewModifier: ViewModifier {
    func body(content: Content) -> some View {content}
}

// MARK: - A Skin that delegates to standard skin implementation
class PreviewSkin: GameSkin {
     func getInLevelGameZoneModifier() -> some ViewModifier {
         PreviewModifier()
    }
}

