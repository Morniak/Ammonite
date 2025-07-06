//
//  AppDelegate.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 16/06/2025.
//

import Foundation
import Cocoa
import SwiftUI
import NotificationCenter

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var menuBarPanel: NSPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        ensureSingleInstance()
        setupMenuBar()
        setupBar()
    }
    
    // MARK: - Menu actions

    @objc func installCLI() {
        CommandLineInstaller.install()
    }
    
    @objc func quit() {
        NSApp.terminate(nil)
    }
}

// MARK: - Private

private extension AppDelegate {
    func ensureSingleInstance() {
        let currentPID = ProcessInfo.processInfo.processIdentifier
        let bundleID = Bundle.main.bundleIdentifier!
        
        let runningInstances = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
        
        for app in runningInstances {
            if app.processIdentifier != currentPID {
                print("Terminating other instance with PID \(app.processIdentifier)")
                app.forceTerminate()
            }
        }
    }
    
    func setupMenuBar() {
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "fossil.shell.fill", accessibilityDescription: Constants.appName)
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Install CLI", action: #selector(installCLI), keyEquivalent: "i"))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem?.menu = menu
    }
    
    func setupBar() {
        guard let screenFrame = NSScreen.main?.frame else { return }
        
        setupPanel(
            &menuBarPanel,
            frame: screenFrame,
            level: Int(CGWindowLevelForKey(.backstopMenu)),
            hostingRootView: AnyView(AmmoniteBar())
        )
    }
    
    func setupPanel(_ panel: inout NSPanel?, frame: CGRect, level: Int, hostingRootView: AnyView) {
        if let existingPanel = panel {
            existingPanel.setFrame(frame, display: true)
            return
        }
        
        let newPanel = NSPanel(
            contentRect: frame,
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        newPanel.level = NSWindow.Level(rawValue: level)
        newPanel.backgroundColor = .clear
        newPanel.hasShadow = false
        newPanel.collectionBehavior = [.canJoinAllSpaces]
        newPanel.contentView = NSHostingView(rootView: hostingRootView)
        newPanel.orderFront(nil)
        panel = newPanel
    }
}
