//
//  GFShareInformation.swift
//  GameFrameKit
//
//  Created by Juergen Boiselle on 28.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import UIKit
import LinkPresentation

public enum GFShareInformation {
    case Score(_ id: String, text: (GFScore) -> String)
    case Achievement(_ id: String, format: String, text: (GFAchievement, String) -> String)
    case Consumable(_ id: String, text: (GFConsumable) -> String)
    case NonConsumable(_ id: String, text: (GFNonConsumable) -> String)
    
    internal func asString() -> String {
        switch self {
        case let .Score(_: id, text: closure):
            return closure(GameFrame.coreData.getScore(id))
        case let .Achievement(_: id, format: format, text: closure):
            return closure(GameFrame.coreData.getAchievement(id), format)
        case let .Consumable(_: id, text: closure):
            return closure(GameFrame.coreData.getConsumable(id))
        case let .NonConsumable(_: id, text: closure):
            return closure(GameFrame.coreData.getNonConsumable(id))
        }
    }
}

public class GFShare: NSObject {
    // MARK: - Initializaton
    internal init(_ window: UIWindow?, appId: Int, infos: [GFShareInformation], greeting: String?) {
        log()
        self.window = window
        self.infos = infos
        self.url = URL(string: "https://itunes.apple.com/app/id\(appId)")
        self.appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        self.greeting = greeting ?? ""
        self.logo = nil
        
        super.init()
        
        self.logo = getLogo()
        self.greeting = greeting ?? appName
    }

    // MARK: - Public functions
    /**
     Collects available information and shows system view to share with others.
     
     Applications to share with are defined by the player.
     - Parameter bounds: Frame of the screenshot, that will be appended
     */
    public func show(bounds: CGRect?) {
        var items = [Any]()
        items.append(ShareItemSource(greeting: greeting, appName: appName))
        for info in infos {items.append(info.asString())}
        if let bounds = bounds, let screenshot = getScreenhot(bounds: bounds) {
            log(screenshot.size)
            items.append(screenshot)
        } else if let logo = getLogo() {
            log(logo.size)
            items.append(logo)
        }
        if let url = url {items.append(url)}
        
        // Create and show view
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        window?.rootViewController?.present(ac, animated: true)
    }

    // MARK: - Internals
    private let window: UIWindow?
    private let url: URL?
    private let infos: [GFShareInformation]
    private var greeting: String
    private let appName: String
    private var logo: UIImage?
    
    private func getLogo() -> UIImage? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any] else {return nil}
        guard let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any] else {return nil}
        guard let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String] else {return nil}
        guard let lastIcon = iconFiles.last else {return nil}
        
        log(lastIcon)
        return UIImage(named: lastIcon)
    }

    private func getScreenhot(bounds: CGRect) -> UIImage? {
        return UIGraphicsImageRenderer(bounds: bounds).image {
            window?.layer.render(in: $0.cgContext)
        }
    }
}

private class ShareItemSource: NSObject, UIActivityItemSource {
    private let greeting: String
    private let appName: String

    fileprivate init(greeting: String, appName: String) {
        self.greeting = greeting
        self.appName = appName
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return greeting
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return greeting
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return greeting
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = appName
        // Providing url's here means to remove the default behaviour to use the AppIcon
        return metadata
    }
}
