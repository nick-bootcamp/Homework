//
//  AccountRow.swift
//  PNCMobileApp
//
//  Created by user301407 on 9/9/26.
//

import SwiftUI

struct AccountRowView: View {
    var  account: Account

    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text(account.name)
                    .font(.headline)
                Text(account.maskedNumber)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(account.balance, format: .currency(code: "USD"))
                .font(.body.monospacedDigit())
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(account.name), \(account.maskedNumber), \(account.balance, format: .currency(code: "USD"))")
        // TODO: Lay out account.name, account.maskedNumber, and
        // account.balance (currency-formatted) in an HStack/VStack
        // combination. Use Dynamic-Type-aware font styles only — no
        // .font(.system(size:)). Add accessibilityElement(children: .combine)
        // and a single, readable accessibilityLabel for the whole row.
        //Text("TODO: implement AccountRow")
    }
}
