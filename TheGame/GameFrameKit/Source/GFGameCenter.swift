//
//  GFGameCenter.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 28.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import GameKit

/**
 Handle GameCenter related features.
 
 This class offers:
 - Reporting of `Achievement` and `Score` to the corresponding GameCenter achievements and leaderboards.
 - Values are automatially reported, when data is saved, at the end of each level, when an achievement was reached or when a new high score was reached.
 - Check if GameCenter is enabled and show Apple's GameCenter including its login page. You can put the `show()` as action to a button and call disable on the button, if GameCenter is not `enabled`
 */
public class GFGameCenter: NSObject, ObservableObject {
    // MARK: - Initialization
    internal override init() {
        log()
        super.init()
        
        GKLocalPlayer.local.authenticateHandler = {
            (viewController, error) in
            
            log(viewController != nil)
            guard check(error) else {return}
            
            if let viewController = viewController {
                self.uiController = viewController
            }

            // User authenticated
            if GKLocalPlayer.local.isAuthenticated {self.report()}
            self.enabled = self.uiController != nil || GKLocalPlayer.local.isAuthenticated
            GKAccessPoint.shared.isActive = self.enabled
            log(GKAccessPoint.shared.isActive, GKLocalPlayer.local.isAuthenticated, self.enabled)
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
            rootViewController?.present(gc, animated: true)
        } else if let uiController = uiController {
            rootViewController?.present(uiController, animated: true)
        }
    }

    // MARK: - Internal handling
    private var uiController: UIViewController? = nil
    private let gcControllerDelegate = GCControllerDelegate()

    internal func report() {
        guard GKLocalPlayer.local.isAuthenticated else {return}
        
        scores.forEach {
            (key: String, value: GFScore) in
            GKLeaderboard.submitScore(
                value.current, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [key]) {
                (error) in
                guard check(error) else {return}
            }
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
