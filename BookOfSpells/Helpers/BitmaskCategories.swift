//
//  BitmaskCategories.swift
//  BalanceGame
//
//  Created by Valados on 22.06.2022.
//

import Foundation

struct BitmaskCategories {
    static let beam: UInt32 = 0x1 << 1
    static let ball: UInt32 = 0x1 << 2
    static let anchor: UInt32 = 0x1 << 3
    static let innerArea: UInt32 = 0x1 << 4
    static let outerArea: UInt32 = 0x1 << 5
}

let GameFont = "SourceSansPro-Bold"
let MuteKey = "MuteKey"
let HighscoreKey = "Highscore"

