//
//  Navigator.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 10.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/**
 After some time with NavigationView, I decided to write my own Navigation. Without bugs that makes the views bounce for and back. With more freedom to run
 custom transitions and animations. With flexibility for the navigation bar.
 
 This NavigatorView called GameNavigatorView, contains of:
 - A stack, that keeps track of the history of shown screens
 - You can push and pop view, as well as peek the current view.
 - A navigation bar is optionally placed on top, with optional leading back button, other navigation items being placed on trailing side and a centered title view.
 */
class GameNavigationModel: NSObject, ObservableObject {
    enum GameNavigation {
        case OffLevel(title: String)
        case InLevel(title: String)
        case Store(title: String)
        case Settings(title: String)
        
        fileprivate var title: String {
            switch self {
            case let .OffLevel(title: title):
                return title
            case let .InLevel(title: title):
                return title
            case let .Store(title: title):
                return title
            case let .Settings(title: title):
                return title
            }
        }
    }
    
    private var stack = [GameNavigation]()
    @Published var current: GameNavigation
    
    init(startsOffLevel: Bool, offLevelTitle: String, inLevelTitle: String) {
        stack.append(.OffLevel(title: offLevelTitle))
        if !startsOffLevel {stack.append(.InLevel(title: inLevelTitle))}
        
        current = stack.last!
    }
    
    func push(_ view: GameNavigation) {
        stack.append(view)
        current = stack.last!
    }
    
    func pop() {
        guard stack.count > 1 else {
            log("Already at first screen!")
            return
        }
        stack.removeLast()
        current = stack.last!
    }
    
    func canGoBack() -> Bool {
        return stack.count >= 2
    }
    
    func prevTitle() -> String {
        guard canGoBack() else {return ""}
        return stack[stack.count - 2].title
    }
}
