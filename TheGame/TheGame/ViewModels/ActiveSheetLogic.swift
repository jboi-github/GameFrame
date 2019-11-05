//
//  ActiveSheetLogic.swift
//  TheGame
//
//  Created by Juergen Boiselle on 02.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import SwiftUI

// Singleton instance
var activeSheet = AcitveSheetLogic()

class AcitveSheetLogic: NSObject, ObservableObject {
    fileprivate override init() {
        current = .OffLevel
        super.init()
    }
    
    private var sheets = [SheetType]()
    private var segues = [SheetType: [SheetType : () -> Void]]()

    /// Possible sheets and screens
    enum SheetType {
        case OffLevel, InLevel, Store, Offer, Wait
    }

    /// Currently set sheet. MainView logic uses this attribute to actually set the right sheet
    @Published private(set) var current: SheetType
    
    /// Next sheet to be visible
    func next(_ sheetType: SheetType) {
        sheets.append(current)
        while sheets.count > 3 {_ = sheets.removeFirst()}
        
        act(current, sheetType)
        current = sheetType
        print(sheets)
    }
    
    /// Pop last visible screen
    func back() {
        let next = sheets.popLast() ?? .OffLevel
        act(current, next)
        current = next
        print(sheets)
    }
    
    /// Set action for segue from one sheet to the next one
    func segue(from: [SheetType], to: [SheetType], action: @escaping () -> Void) {
        for sheetFrom in from {
            _ = segues.getAndAddIfNotExisting(key: sheetFrom) {
                (sheetFrom) -> [SheetType : () -> Void] in
                
                var seguesTo = [SheetType : () -> Void]()
                for sheetTo in to {
                    _ = seguesTo.getAndAddIfNotExisting(key: sheetTo) {
                        (sheetTo) -> () -> Void in
                        action
                    }
                }
                return seguesTo
            }
        }
    }
    
    private func act(_ current: SheetType, _ next: SheetType) {
        guard let segues = segues[current] else {return}
        guard let action = segues[next] else {return}
        
        action()
    }
}
