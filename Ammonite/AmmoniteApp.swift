//
//  AmmoniteApp.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 16/06/2025.
//

import SwiftUI

@main
struct AmmoniteApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
