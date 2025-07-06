//
//  CommandLineInstaller.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation

struct CommandLineInstaller {
    static func install(installationDirectory: URL = URL(string:"/usr/local/bin/")!) {
        guard let cliSourcePath = Bundle.main.path(forResource: "ammonite", ofType: nil) else {
            print("❌ CLI not found in bundle.")
            return
        }
        
        let destinationPath = installationDirectory.appendingPathComponent("ammonite").path
        
        let script =
            """
            do shell script "cp \(cliSourcePath) \(destinationPath) && chmod +x \(destinationPath)" with administrator privileges
            """
        
        guard let scriptObject = NSAppleScript(source: script) else {
            return
        }
        
        DispatchQueue(label: "background_queue", qos: .background).async {
            var error: NSDictionary?
            
            scriptObject.executeAndReturnError(&error)
            
            if let error = error {
                print("❌ Error: \(error)")
            } else {
                print("✅ CLI installed")
            }
        }
    }
}
