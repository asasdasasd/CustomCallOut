//
//  Sequence+Ext.swift
//  CustomCallOutDemo
//
//  Created by shen
//  Copyright © 2016年 shen. All rights reserved.
//

import Foundation

public extension Sequence {
    func categorise<U: Hashable>(_ key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var dict: [U: [Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) {
                dict[key] = [el]
            }
        }
        return dict
        
    }
}
