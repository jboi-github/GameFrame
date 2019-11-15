//
//  TheGameSkin.swift
//  TheGame
//
//  Created by Juergen Boiselle on 13.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

// MARK: The GameZone View
struct TheGameZoneModifier: ViewModifier {
    var geometryProxy: GeometryProxy

    func body(content: Content) -> some View {TheGameView().background(Color.red)}
}

// MARK: - A Skin that delegates to standard skin implementation
class TheGameSkin: Skin {
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
     func getInLevelGameZoneModifier(geometryProxy: GeometryProxy) -> some ViewModifier {
         TheGameZoneModifier(geometryProxy: geometryProxy)
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
