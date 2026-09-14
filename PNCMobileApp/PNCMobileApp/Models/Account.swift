//
//  Account.swift
//  PNCMobileApp
//
//  Created by user301407 on 9/9/26.
//

import SwiftUI

struct Account: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let maskedNumber: String
    let balance: Decimal
}

let sampleAccounts: [Account] = [
    Account(name: "Everyday Checking", maskedNumber: "\u{2022}\u{2022}\u{2022}\u{2022} 4471", balance: 4281.16),
    Account(name: "High Yield Savings", maskedNumber: "\u{2022}\u{2022}\u{2022}\u{2022} 9902", balance: 18_340.50),
    Account(name: "Rewards Credit Card", maskedNumber: "\u{2022}\u{2022}\u{2022}\u{2022} 2216", balance: -612.44),
]
