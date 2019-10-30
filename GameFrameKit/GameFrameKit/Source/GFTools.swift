//
//  HelperTools.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import StoreKit

/**
 Get value from dictionary if key already exists. If key does not exist, use closure to create value, put it into dictionary and return it.
 The algorithm guarantees, that
 - Key in dictionary is located only once
 - New value is only created, if none exists, yet
 
 - Parameter key: key in dctionary to look for
 - Parameter closure: Closure to create a new value
 - returns: The found or created value
 */
public extension Dictionary {
    mutating func getAndAddIfNotExisting(key: Key, closure: (Key) -> Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            let value = closure(key)
            self[key] = value
            return value
        }
    }
}

/// Allows formatting a Double in String-interpolation, e.g. \(<#some double var#>.format(".2")
public extension Double {
    func format(_ format: String) -> String {
        return String(format: "%\(format)f", self)
    }
}

/// Handle errors.
/// Returns true, if check was succesful, false if error occured
internal func check(
    _ error: Error?,
    function: String = #function, file: String = #file, line: Int = #line, col: Int = #column) -> Bool {
    
    if let error = error {
        log("Error: \(error.localizedDescription)", function: function, file: file, line: line, col: col)
        return false
    }
    return true
}

/// - returns: Action for Buttons, that opens and external URL
public func getUrlAction(_ url: String) -> () -> Void {
    if let url = URL(string: url) {
        return {UIApplication.shared.open(url)}
    } else {
        return {} // Do nothing
    }
}

/// - returns: The cost of the product formatted in the local currency.
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}

public var maxLogLevel = Int.max

/**
 Write a log message to standard output. It adds "*GF" at the beginning of the message + information to easily locate, where the log was written.
 - Parameter level: Corresponds to the `maxLogLevel` global variable. If `level > maxLogLevel` then the function does nothing. This is useful for production environments. Set the globale variable to a high value before distributing the App. Default for level is 0, so that log message are printed by default.
 */
public func log(
    level: Int = 0,
    _ msg: Any?...,
    function: String = #function, file: String = #file, line: Int = #line, col: Int = #column,
    terminator: String = "\n", separator: String = " ")
{
    guard level <= maxLogLevel else {return}
    
    print("* GF: \(URL(fileURLWithPath: file).lastPathComponent): \(function)(\(line), \(col)): ", msg,
          separator: separator, terminator: terminator)
}
