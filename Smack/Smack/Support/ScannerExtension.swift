//
//  ScannerExtension.swift
//  Smack
//
//  Created by Chris Mercer on 16/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation

extension Substring {
    mutating func scan(_ condition: (Element) -> Bool) -> Element? {
        guard let f = first, condition(f) else { return nil }
        return removeFirst()
    }

    mutating func scan(count: Int) -> Substring? {
        let result = prefix(count)
        guard result.count == count else { return nil }
        removeFirst(count)
        return result
    }

    mutating func scan<C>(prefix: C) -> Bool where C: Collection, C.Element == Character {
        guard starts(with: prefix) else { return false }
        removeFirst(prefix.count)
        return true
    }
}
