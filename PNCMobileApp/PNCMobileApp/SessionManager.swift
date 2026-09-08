//
//  SessionManager.swift
//  PNCMobileApp
//
//  Created by user301407 on 9/4/26.
//


import SwiftUI
internal import Combine

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    var isSessionExpired: Bool = false
    @Published var backgroundTimestamp: Date?
    
    func recordBackgroundTimestamp() {
        backgroundTimestamp = Date()
    }

    func evaluateSessionTimeout() {
        guard let backgroundTimestamp else {
            return
        }
        let elapsedTime = Date().timeIntervalSince(backgroundTimestamp)
        guard elapsedTime >= 300 else{
            return
        }
        isLoggedIn = false
        isSessionExpired = true
        self.backgroundTimestamp = nil
    }

}
