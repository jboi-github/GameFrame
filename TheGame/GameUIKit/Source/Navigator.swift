//
//  Navigator.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 10.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

/**
 After some time with NavigationView, I decided to write my own Navigation. Without bugs that makes the views bounce for and back. With more freedom to run
 custom transitions and animations. With flexibility for the navigation bar.
 
 This NavigatorView called GameNavigatorView, contains of:
 - A stack, that keeps track of the history of shown screens
 - You can push and pop view, as well as peek the current view.
 - A navigation bar is optionally placed on top, with optional leading back button, other navigation items being placed on trailing side and a centered title view.
 */
// DONE: MainView shows current view from stack
// DONE: Model for stack
// DONE: NavigaitonLayer has buttons instead of navigationlinks
// DONE: Back button for navigation bar
// TODO: MainView gets fixed navigation bar. Modifier has "current" naming to differentiate
// DONE: Can navigation bar be fully handled with existing navigation layer?

class GameNavigationModel: NSObject, ObservableObject {
    enum GameNavigation {
        case OffLevel, InLevel, Store, Settings
    }
    
    private var stack = [GameNavigation]()
    @Published var current: GameNavigation
    
    init(startsOffLevel: Bool) {
        stack.append(.OffLevel)
        if !startsOffLevel {stack.append(.InLevel)}
        
        current = stack.last!
    }
    
    func push(_ view: GameNavigation) {
        stack.append(view)
        current = stack.last!
    }
    
    func pop() {
        stack.removeLast()
        current = stack.last! // Crashes, when pop more then pushed
    }
    
    func canGoBack() -> Bool {
        return stack.count > 1
    }
}
