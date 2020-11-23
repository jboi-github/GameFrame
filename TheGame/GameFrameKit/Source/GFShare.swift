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
    internal init(appId: String, infos: [GFShareInformation], greeting: String?) {
        log()
        self.infos = infos
        self.url = URL(string: getStoreUrl(appId: appId))
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
    public func show(buttonFrame: CGRect, bounds: CGRect?) {
        // Build the information items
        let screenshot = bounds != nil ? getScreenhot(bounds: bounds!) : nil
        let imageUrl = screenshot != nil ? urlForImage(image: screenshot!) : nil
        let shareItemSource = ShareItemSource(greeting: greeting, appName: appName, imageUrl: imageUrl)
        let infoStrings = infos.map {$0.asString()}

        // Put into activity items
        var items = [Any]()
        items.append(shareItemSource)
        items.append(contentsOf: infoStrings)
        if let screenshot = screenshot {
            items.append(screenshot)
        } else if let logo = logo {
            items.append(logo)
        }
        if let url = url {items.append(url)}
        //if let imageUrl = imageUrl {items.append(imageUrl)}
        
        // Create and show view
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        //If user on iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let rootViewController = rootViewController {
                ac.popoverPresentationController?.sourceView = rootViewController.view
                ac.popoverPresentationController?.sourceRect = buttonFrame
                rootViewController.present(ac, animated: true)
                return
            }
        } else {
            //Present the shareView on iPhone
            rootViewController?.present(ac, animated: true)
        }
    }

    // MARK: - Internals
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
            UIApplication
                .shared
                .windows
                .first(where: { (window) -> Bool in window.isKeyWindow})?
                .layer.render(in: $0.cgContext)
        }
    }
    
    private func urlForImage(image: UIImage) -> URL? {
        guard let data = image.pngData() else {return nil}
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("screenshot.png", isDirectory: false)
        log(url)
        
        do {
            try data.write(to: url)
            log()
        } catch {
            guard check(error) else {return nil}
        }
        return url
    }
}

private class ShareItemSource: NSObject, UIActivityItemSource {
    private let greeting: String
    private let appName: String
    private let imageUrl: URL?

    fileprivate init(greeting: String, appName: String, imageUrl: URL?) {
        self.greeting = greeting
        self.appName = appName
        self.imageUrl = imageUrl
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
        //metadata.iconProvider = NSItemProvider(contentsOf: imageUrl)
        //metadata.imageProvider = NSItemProvider(contentsOf: imageUrl)
        //metadata.url = imageUrl
        //metadata.originalURL = imageUrl
        
        // Providing url and originalUrl here means to remove the default behaviour to use the AppIcon
        return metadata
    }
}
