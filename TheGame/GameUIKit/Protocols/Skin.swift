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
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {
        content
        .navigationBarTitle("No Title")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {
        content
        .navigationBarTitle("No Title")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .padding()
    }
}

struct OffLevelNavigationModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct OffLevelInformationModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct OffLevelPlayButtonModifier: ButtonStyle {
    var geometryProxy: GeometryProxy
    var isDisabled: Bool

   func makeBody(configuration: Self.Configuration) -> some View {
        Image(systemName: "play.circle")
            .resizable().scaledToFit()
            .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

struct InLevelModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var isOverlayed: Bool

    func body(content: Content) -> some View {
        content
        .navigationBarTitle("No Title")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .blur(radius: isOverlayed ? 5.0 : 0.0)
        .padding()
    }
}

struct InLevelNavigationModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct InLevelInformationModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct InLevelGameZoneModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct StoreModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var isOverlayed: Bool

    func body(content: Content) -> some View {
        content
        .navigationBarTitle("No Title")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .blur(radius: isOverlayed ? 5.0 : 0.0)
        .padding()
    }
}

struct StoreEmptyModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct StoreNavigationModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct StoreConsumablesModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct StoreConsumableModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var id: String

    func body(content: Content) -> some View {
        content.padding(.vertical, nil)
    }
}

struct StoreConsumableButtonModifier: ButtonStyle {
    var geometryProxy: GeometryProxy
    var isDisabled: Bool
    var id: String

   func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
            .frame(width: geometryProxy.size.width * 1.0/4.0)
    }
}

struct StoreConsumableTitleModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct StoreConsumableDescriptionModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct StoreConsumableQuantityModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct StoreConsumableStepperModifier: ButtonStyle {
    var geometryProxy: GeometryProxy
    var isDisabled: Bool

   func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
            .frame(width: geometryProxy.size.width * 1.0/3.0)
    }
}

struct StoreConsumableCartModifier: ImageModifier {
    var geometryProxy: GeometryProxy

   func body(image: Image) -> some View {image}
}

struct StoreConsumablePriceModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct StoreNonConsumablesModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct StoreNonConsumableModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var id: String

    func body(content: Content) -> some View {
        content.padding(.vertical, nil)
    }
}

struct StoreNonConsumableButtonModifier: ButtonStyle {
    var geometryProxy: GeometryProxy
    var isDisabled: Bool
    var id: String

   func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

struct StoreNonConsumableTitleModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct StoreNonConsumableDescriptionModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct StoreNonConsumableCartModifier: ImageModifier {
    var geometryProxy: GeometryProxy

   func body(image: Image) -> some View {image}
}

struct StoreNonConsumablePriceModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct OfferModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {
        content
        .padding()
        .background(Color.secondary.colorInvert())
    }
}

struct OfferNavigationModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct OfferProductsModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

struct OfferProductModifier: ButtonStyle {
    var geometryProxy: GeometryProxy
    var isDisabled: Bool
    var id: String

   func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

struct OfferProductTitleModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct OfferProductDescriptionModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct OfferProductCartModifier: ImageModifier {
    var geometryProxy: GeometryProxy

   func body(image: Image) -> some View {image}
}

struct OfferProductPriceModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct InformationAchievementsModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var parent: String

    func body(content: Content) -> some View {content}
}

struct InformationAchievementModifier: TextModifier {
    var geometryProxy: GeometryProxy
    var parent: String
    var id: String

    func body(text: Text) -> some View {text}
}

struct InformationScoresModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var parent: String

    func body(content: Content) -> some View {content}
}

struct InformationScoreModifier: TextModifier {
    var geometryProxy: GeometryProxy
    var parent: String
    var id: String

    func body(text: Text) -> some View {text}
}

struct InformationConsumablesModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var parent: String

    func body(content: Content) -> some View {content}
}

struct InformationConsumableModifier: TextModifier {
    var geometryProxy: GeometryProxy
    var parent: String
    var id: String

    func body(text: Text) -> some View {text}
}

struct InformationNonConsumablesModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var parent: String

    func body(content: Content) -> some View {content}
}

struct InformationNonConsumableModifier: ViewModifier {
    var geometryProxy: GeometryProxy
    var parent: String
    var id: String

    func body(content: Content) -> some View {content}
}

struct NavigatableModifier: ButtonStyle {
    var geometryProxy: GeometryProxy
    var parent: String
    var isDisabled: Bool
    var id: Int

   func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

struct WaitWithErrorModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {
        content
        .padding()
        .background(Color.secondary.colorInvert())
    }
}

struct WaitModifier: ViewModifier {
    var geometryProxy: GeometryProxy

   func body(content: Content) -> some View {content}
}

struct ErrorMessageModifier: TextModifier {
    var geometryProxy: GeometryProxy

    func body(text: Text) -> some View {text}
}

struct ErrorButtonModifier: ButtonStyle {
    var geometryProxy: GeometryProxy
    var isDisabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
    }
}

public protocol Skin {
    associatedtype MainModifierType: ViewModifier
    associatedtype MainBannerModifierType: ViewModifier
    associatedtype MainBannerEmptyModifierType: ViewModifier
    associatedtype OffLevelModifierType: ViewModifier
    associatedtype OffLevelNavigationModifierType: ViewModifier
    associatedtype OffLevelInformationModifierType: ViewModifier
    associatedtype OffLevelPlayButtonModifierType: ButtonStyle
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
    associatedtype InformationAchievementsModifierType: ViewModifier
    associatedtype InformationAchievementModifierType: TextModifier
    associatedtype InformationScoresModifierType: ViewModifier
    associatedtype InformationScoreModifierType: TextModifier
    associatedtype InformationConsumablesModifierType: ViewModifier
    associatedtype InformationConsumableModifierType: TextModifier
    associatedtype InformationNonConsumablesModifierType: ViewModifier
    associatedtype InformationNonConsumableModifierType: ViewModifier
    associatedtype NavigatableModifierType: ButtonStyle
    associatedtype WaitWithErrorModifierType: ViewModifier
    associatedtype WaitModifierType: ViewModifier
    associatedtype ErrorMessageModifierType: TextModifier
    associatedtype ErrorButtonModifierType: ButtonStyle
    
    func getMainModifier(geometryProxy: GeometryProxy) -> MainModifierType
    func getMainBannerModifier(width: CGFloat, height: CGFloat) -> MainBannerModifierType
    func getMainBannerEmptyModifier() -> MainBannerEmptyModifierType
    func getOffLevelModifier(geometryProxy: GeometryProxy) -> OffLevelModifierType
    func getOffLevelNavigationModifier(geometryProxy: GeometryProxy) -> OffLevelNavigationModifierType
    func getOffLevelInformationModifier(geometryProxy: GeometryProxy) -> OffLevelInformationModifierType
    func getOffLevelPlayButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool) -> OffLevelPlayButtonModifierType
    func getInLevelModifier(geometryProxy: GeometryProxy, isOverlayed: Bool) -> InLevelModifierType
    func getInLevelNavigationModifier(geometryProxy: GeometryProxy) -> InLevelNavigationModifierType
    func getInLevelInformationModifier(geometryProxy: GeometryProxy) -> InLevelInformationModifierType
    func getInLevelGameZoneModifier(geometryProxy: GeometryProxy) -> InLevelGameZoneModifierType
    func getStoreModifier(geometryProxy: GeometryProxy, isOverlayed: Bool) -> StoreModifierType
    func getStoreEmptyModifier(geometryProxy: GeometryProxy) -> StoreEmptyModifierType
    func getStoreNavigationModifier(geometryProxy: GeometryProxy) -> StoreNavigationModifierType
    func getStoreConsumablesModifier(geometryProxy: GeometryProxy) -> StoreConsumablesModifierType
    func getStoreConsumableModifier(geometryProxy: GeometryProxy, id: String) -> StoreConsumableModifierType
    func getStoreConsumableButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool, id: String) -> StoreConsumableButtonModifierType
    func getStoreConsumableTitleModifier(geometryProxy: GeometryProxy) -> StoreConsumableTitleModifierType
    func getStoreConsumableDescriptionModifier(geometryProxy: GeometryProxy) -> StoreConsumableDescriptionModifierType
    func getStoreConsumableQuantityModifier(geometryProxy: GeometryProxy) -> StoreConsumableQuantityModifierType
    func getStoreConsumableStepperModifier(geometryProxy: GeometryProxy, isDisabled: Bool) -> StoreConsumableStepperModifierType
    func getStoreConsumableCartModifier(geometryProxy: GeometryProxy) -> StoreConsumableCartModifierType
    func getStoreConsumablePriceModifier(geometryProxy: GeometryProxy) -> StoreConsumablePriceModifierType
    func getStoreNonConsumablesModifier(geometryProxy: GeometryProxy) -> StoreNonConsumablesModifierType
    func getStoreNonConsumableModifier(geometryProxy: GeometryProxy, id: String) -> StoreNonConsumableModifierType
    func getStoreNonConsumableButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool, id: String) -> StoreNonConsumableButtonModifierType
    func getStoreNonConsumableTitleModifier(geometryProxy: GeometryProxy) -> StoreNonConsumableTitleModifierType
    func getStoreNonConsumableDescriptionModifier(geometryProxy: GeometryProxy) -> StoreNonConsumableDescriptionModifierType
    func getStoreNonConsumableCartModifier(geometryProxy: GeometryProxy) -> StoreNonConsumableCartModifierType
    func getStoreNonConsumablePriceModifier(geometryProxy: GeometryProxy) -> StoreNonConsumablePriceModifierType
    func getOfferModifier(geometryProxy: GeometryProxy) -> OfferModifierType
    func getOfferNavigationModifier(geometryProxy: GeometryProxy) -> OfferNavigationModifierType
    func getOfferProductsModifier(geometryProxy: GeometryProxy) -> OfferProductsModifierType
    func getOfferProductModifier(geometryProxy: GeometryProxy, isDisabled: Bool, id: String) -> OfferProductModifierType
    func getOfferProductTitleModifier(geometryProxy: GeometryProxy) -> OfferProductTitleModifierType
    func getOfferProductDescriptionModifier(geometryProxy: GeometryProxy) -> OfferProductDescriptionModifierType
    func getOfferProductCartModifier(geometryProxy: GeometryProxy) -> OfferProductCartModifierType
    func getOfferProductPriceModifier(geometryProxy: GeometryProxy) -> OfferProductPriceModifierType
    func getInformationAchievementsModifier(geometryProxy: GeometryProxy, parent: String) -> InformationAchievementsModifierType
    func getInformationAchievementModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> InformationAchievementModifierType
    func getInformationScoresModifier(geometryProxy: GeometryProxy, parent: String) -> InformationScoresModifierType
    func getInformationScoreModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> InformationScoreModifierType
    func getInformationConsumablesModifier(geometryProxy: GeometryProxy, parent: String) -> InformationConsumablesModifierType
    func getInformationConsumableModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> InformationConsumableModifierType
    func getInformationNonConsumablesModifier(geometryProxy: GeometryProxy, parent: String) -> InformationNonConsumablesModifierType
    func getInformationNonConsumableModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> InformationNonConsumableModifierType
    func getNavigatableModifier(geometryProxy: GeometryProxy, parent: String, isDisabled: Bool, id: Int) -> NavigatableModifierType
    func getWaitWithErrorModifier(geometryProxy: GeometryProxy) -> WaitWithErrorModifierType
    func getWaitModifier(geometryProxy: GeometryProxy) -> WaitModifierType
    func getErrorMessageModifier(geometryProxy: GeometryProxy) -> ErrorMessageModifierType
    func getErrorButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool) -> ErrorButtonModifierType
}

public extension Skin {
     func getMainModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         return MainModifier(geometryProxy: geometryProxy)
    }
      func getMainBannerModifier(width: CGFloat, height: CGFloat) -> some ViewModifier {
          MainBannerModifier(width: width, height: height)
     }
      func getMainBannerEmptyModifier() -> some ViewModifier {
          MainBannerEmptyModifier()
     }
      func getOffLevelModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
          OffLevelModifier(geometryProxy: geometryProxy)
     }
      func getOffLevelNavigationModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
          OffLevelNavigationModifier(geometryProxy: geometryProxy)
     }
      func getOffLevelInformationModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
          OffLevelInformationModifier(geometryProxy: geometryProxy)
     }
      func getOffLevelPlayButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool) -> some ButtonStyle {
          OffLevelPlayButtonModifier(geometryProxy: geometryProxy, isDisabled: isDisabled)
     }
      func getInLevelModifier(geometryProxy: GeometryProxy, isOverlayed: Bool) -> some ViewModifier {
          InLevelModifier(geometryProxy: geometryProxy, isOverlayed: isOverlayed)
     }
      func getInLevelNavigationModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
          InLevelNavigationModifier(geometryProxy: geometryProxy)
     }
      func getInLevelInformationModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
          InLevelInformationModifier(geometryProxy: geometryProxy)
     }
     func getStoreModifier(geometryProxy: GeometryProxy, isOverlayed: Bool) -> some ViewModifier {
         StoreModifier(geometryProxy: geometryProxy, isOverlayed: isOverlayed)
    }
     func getStoreEmptyModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreEmptyModifier(geometryProxy: geometryProxy)
    }
     func getStoreNavigationModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         StoreNavigationModifier(geometryProxy: geometryProxy)
    }
     func getStoreConsumablesModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         StoreConsumablesModifier(geometryProxy: geometryProxy)
    }
      func getStoreConsumableModifier(geometryProxy: GeometryProxy, id: String) -> some ViewModifier {
          StoreConsumableModifier(geometryProxy: geometryProxy, id: id)
     }
      func getStoreConsumableButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool, id: String) -> some ButtonStyle {
          StoreConsumableButtonModifier(geometryProxy: geometryProxy, isDisabled: isDisabled, id: id)
     }
     func getStoreConsumableTitleModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreConsumableTitleModifier(geometryProxy: geometryProxy)
    }
     func getStoreConsumableDescriptionModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreConsumableDescriptionModifier(geometryProxy: geometryProxy)
    }
     func getStoreConsumableQuantityModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreConsumableQuantityModifier(geometryProxy: geometryProxy)
    }
     func getStoreConsumableStepperModifier(geometryProxy: GeometryProxy, isDisabled: Bool) -> some ButtonStyle {
         StoreConsumableStepperModifier(geometryProxy: geometryProxy, isDisabled: isDisabled)
    }
     func getStoreConsumableCartModifier(geometryProxy: GeometryProxy) -> some ImageModifier {
         StoreConsumableCartModifier(geometryProxy: geometryProxy)
    }
     func getStoreConsumablePriceModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreConsumablePriceModifier(geometryProxy: geometryProxy)
    }
      func getStoreNonConsumablesModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
          StoreNonConsumablesModifier(geometryProxy: geometryProxy)
     }
     func getStoreNonConsumableModifier(geometryProxy: GeometryProxy, id: String) -> some ViewModifier {
         StoreNonConsumableModifier(geometryProxy: geometryProxy, id: id)
     }
     func getStoreNonConsumableButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool, id: String) -> some ButtonStyle {
         StoreNonConsumableButtonModifier(geometryProxy: geometryProxy, isDisabled: isDisabled, id: id)
    }
     func getStoreNonConsumableTitleModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreNonConsumableTitleModifier(geometryProxy: geometryProxy)
    }
     func getStoreNonConsumableDescriptionModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreNonConsumableDescriptionModifier(geometryProxy: geometryProxy)
    }
     func getStoreNonConsumableCartModifier(geometryProxy: GeometryProxy) -> some ImageModifier {
         StoreNonConsumableCartModifier(geometryProxy: geometryProxy)
    }
     func getStoreNonConsumablePriceModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         StoreNonConsumablePriceModifier(geometryProxy: geometryProxy)
    }
     func getOfferModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         OfferModifier(geometryProxy: geometryProxy)
    }
     func getOfferNavigationModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         OfferNavigationModifier(geometryProxy: geometryProxy)
    }
     func getOfferProductsModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         OfferProductsModifier(geometryProxy: geometryProxy)
    }
     func getOfferProductModifier(geometryProxy: GeometryProxy, isDisabled: Bool, id: String) -> some ButtonStyle {
         OfferProductModifier(geometryProxy: geometryProxy, isDisabled: isDisabled, id: id)
    }
     func getOfferProductTitleModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         OfferProductTitleModifier(geometryProxy: geometryProxy)
    }
     func getOfferProductDescriptionModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         OfferProductDescriptionModifier(geometryProxy: geometryProxy)
    }
     func getOfferProductCartModifier(geometryProxy: GeometryProxy) -> some ImageModifier {
         OfferProductCartModifier(geometryProxy: geometryProxy)
    }
     func getOfferProductPriceModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         OfferProductPriceModifier(geometryProxy: geometryProxy)
    }
     func getInformationAchievementsModifier(geometryProxy: GeometryProxy, parent: String) -> some ViewModifier {
        InformationAchievementsModifier(geometryProxy: geometryProxy, parent: parent)
    }
     func getInformationAchievementModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> some TextModifier {
         InformationAchievementModifier(geometryProxy: geometryProxy, parent: parent, id: id)
    }
     func getInformationScoresModifier(geometryProxy: GeometryProxy, parent: String) -> some ViewModifier {
         InformationScoresModifier(geometryProxy: geometryProxy, parent: parent)
    }
     func getInformationScoreModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> some TextModifier {
         InformationScoreModifier(geometryProxy: geometryProxy, parent: parent, id: id)
    }
     func getInformationConsumablesModifier(geometryProxy: GeometryProxy, parent: String) -> some ViewModifier {
         InformationConsumablesModifier(geometryProxy: geometryProxy, parent: parent)
    }
     func getInformationConsumableModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> some TextModifier {
         InformationConsumableModifier(geometryProxy: geometryProxy, parent: parent, id: id)
    }
     func getInformationNonConsumablesModifier(geometryProxy: GeometryProxy, parent: String) -> some ViewModifier {
         InformationNonConsumablesModifier(geometryProxy: geometryProxy, parent: parent)
    }
     func getInformationNonConsumableModifier(geometryProxy: GeometryProxy, parent: String, id: String) -> some ViewModifier {
         InformationNonConsumableModifier(geometryProxy: geometryProxy, parent: parent, id: id)
    }
    func getNavigatableModifier(geometryProxy: GeometryProxy, parent: String, isDisabled: Bool, id: Int) -> some ButtonStyle {
         NavigatableModifier(geometryProxy: geometryProxy, parent: parent, isDisabled: isDisabled, id: id)
    }
     func getWaitWithErrorModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         WaitWithErrorModifier(geometryProxy: geometryProxy)
    }
     func getWaitModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         WaitModifier(geometryProxy: geometryProxy)
    }
     func getErrorMessageModifier(geometryProxy: GeometryProxy) -> some TextModifier {
         ErrorMessageModifier(geometryProxy: geometryProxy)
    }
     func getErrorButtonModifier(geometryProxy: GeometryProxy, isDisabled: Bool) -> some ButtonStyle {
         ErrorButtonModifier(geometryProxy: geometryProxy, isDisabled: isDisabled)
    }
}

// MARK: - Skin implementation for previews
struct PreviewModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {content}
}

// MARK: - A Skin that delegates to standard skin implementation
class PreviewSkin: Skin {
     func getInLevelGameZoneModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         PreviewModifier(geometryProxy: geometryProxy)
    }
}

