//
//  GFGameCenter.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 28.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import GameKit

/**
 Handle GameCenter related features. This class offers:
 - Reporting of `Achievement` and `Score` to the corresponding GameCenter achievements and leaderboards.
 - Values are automatially reported, when data is saved, at the end of each level, when an achievement was reached or when a new high score was reached.
 - Check if GameCenter is enabled and show Apple's GameCenter including its login page. You can put the `show()` as action to a button and call disable on the button, if GameCenter is not `enabled`
 */
public class GFGameCenter: NSObject, ObservableObject {
    // MARK: - Initialization
    internal init(_ window: UIWindow?) {
        log()
        self.window = window
        super.init()
        
        GKLocalPlayer.local.authenticateHandler = {
            (viewController, error) in
            
            guard check(error) else {return}
            
            if let viewController = viewController {
                self.uiController = viewController
            }
            
            // User authenticated
            if GKLocalPlayer.local.isAuthenticated {self.report()}
            self.enabled = (window != nil) && (self.uiController != nil || GKLocalPlayer.local.isAuthenticated)
        }
    }
    
    // MARK: - Public functions
    /// Usage: If true, it is possible to show GameCenter with `show()`. This means either player is logged in to GameCenter and achievements and scores are reported. Or it means that player allows login and when `show()`is called in this case, it'll show Apples's GameCenter Login page.
    @Published public private(set) var enabled: Bool = false

    /**
     Show GameCenter or login to GameCenter. If `enabled` is false, this function silently ignores the call and does nothing.
     */
    public func show() {
        log()
        guard enabled else {return}
        
        if GKLocalPlayer.local.isAuthenticated {
            let gc = GKGameCenterViewController()
            gc.gameCenterDelegate = gcControllerDelegate
            window?.rootViewController?.present(gc, animated: true, completion:nil)
        } else if let uiController = uiController {
            window?.rootViewController?.present(uiController, animated: true, completion:nil)
        }
    }

    // MARK: - Internal handling
    private let window: UIWindow?
    private var uiController: UIViewController? = nil
    private let gcControllerDelegate = GCControllerDelegate()

    internal func report() {
        guard GKLocalPlayer.local.isAuthenticated else {return}
        
        GKScore.report(scores.map({
            (key: String, value: GFScore) -> GKScore in
            value.getGameCenterReporter(id: key)
        })) {
            (error) in
            guard check(error) else {return}
        }
        
        GKAchievement.report(achievements.map({
            (key: String, value: GFAchievement) -> GKAchievement in
            value.getGameCenterReporter(id: key)
        })) {
            (error) in
            guard check(error) else {return}
        }
    }
}

private class GCControllerDelegate: NSObject, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {        
        log()
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
