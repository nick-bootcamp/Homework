//
//  AccountListView.swift
//  PNCMobileApp
//
//  Created by user301407 on 9/9/26.
//
import SwiftUI

struct AccountListView: View {
    @State var accounts: [Account]

    var body: some View {
        NavigationStack{
            List(accounts) { account in
                NavigationLink(value: account){
                    AccountRowView(account: account)
                }
                .navigationDestination(for: Account.self){account in
                    AccountDetailView(account: account)
                }
                .navigationTitle("Accounts")
            }
        }
        // TODO: Wrap a List of `accounts` in a NavigationStack.
        // Each row should be a NavigationLink(value:) wrapping an
        // AccountRow. Add a .navigationDestination(for: Account.self)
        // that presents AccountDetailView. Set a navigationTitle.
        //Text("TODO: implement AccountListView")
    }
}
