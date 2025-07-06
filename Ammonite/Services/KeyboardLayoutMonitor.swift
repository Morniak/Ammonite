//
//  KeyboardLayoutMonitor.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import SwiftUI
import Carbon

final class KeyboardLayoutMonitor: ObservableObject {
    @Published var currentLayoutName: String = "Unknown"
    private var inputSourceIDs: [String] = []
    
    private var observer: NSObjectProtocol?
    
    init() {
        loadAvailableLayouts()
        updateCurrentLayout()
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    /// Loads the user’s enabled keyboard input sources.
    private func loadAvailableLayouts() {
        let properties: [CFString: Any] = [
            kTISPropertyInputSourceType: kTISTypeKeyboardLayout as Any,
            kTISPropertyInputSourceIsSelectCapable: true,
            kTISPropertyInputSourceIsEnabled: true
        ]
        
        guard let sourceList = TISCreateInputSourceList(properties as CFDictionary, false)?.takeRetainedValue() as? [TISInputSource] else {
            inputSourceIDs = []
            return
        }
        
        inputSourceIDs = sourceList.compactMap {
            if let idPtr = TISGetInputSourceProperty($0, kTISPropertyInputSourceID) {
                return Unmanaged<CFString>.fromOpaque(idPtr).takeUnretainedValue() as String
            }
            return nil
        }
    }
    
    func updateCurrentLayout() {
        guard let inputSource = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else {
            currentLayoutName = "Unknown"
            return
        }
        
        if let namePtr = TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName) {
            let name = Unmanaged<CFString>.fromOpaque(namePtr).takeUnretainedValue() as String
            DispatchQueue.main.async {
                self.currentLayoutName = name
            }
        }
    }
    
    func cycleToNextLayout() {
        guard !inputSourceIDs.isEmpty else { return }
        
        guard let inputSource = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue(),
              let currentIDPtr = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) else {
            return
        }
        
        let currentID = Unmanaged<CFString>.fromOpaque(currentIDPtr).takeUnretainedValue() as String
        
        guard let currentIndex = inputSourceIDs.firstIndex(of: currentID) else { return }
        
        let nextIndex = (currentIndex + 1) % inputSourceIDs.count
        let nextID = inputSourceIDs[nextIndex]
        
        if let sources = TISCreateInputSourceList([kTISPropertyInputSourceID: nextID] as CFDictionary, false)?.takeRetainedValue() as? [TISInputSource],
           let nextSource = sources.first {
            TISSelectInputSource(nextSource)
            updateCurrentLayout()
        }
    }
    
    private func startObserving() {
        observer = DistributedNotificationCenter.default().addObserver(
            forName: NSNotification.Name("com.apple.TISNotifySelectedKeyboardInputSourceChanged"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateCurrentLayout()
        }
    }
    
    private func stopObserving() {
        if let observer = observer {
            DistributedNotificationCenter.default().removeObserver(observer)
        }
    }
}
