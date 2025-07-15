//
//  DefaultContainer+Factories.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 03/07/2025.
//

import Foundation
import Factory

extension AmmoniteContainer {
    var configManager: Factory<ConfigManager> {
        self { ConfigManager() }.singleton
    }

    var commandListener: Factory<CommandListener> {
        self { CommandListener() }.singleton
    }
    
    // MARK: - Workspaces related services
    
    var aerospaceWorkspacesRepository: Factory<AerospaceWorkspacesRepository> {
        self { AerospaceWorkspacesRepository() }.shared
    }
    
    var workspaceSwitcher: Factory<any WorkspaceSwitcher> {
        self { AerospaceWorkspaceSwitcher() }.shared
    }
    
    var workspacesRepository: Factory<any WorkspacesRepository> {
        self { self.aerospaceWorkspacesRepository() }.shared
    }

    // MARK: - Aerospace modes related services
    
    var aerospaceModesInteractor: Factory<AerospaceModesInteractor> {
        self { AerospaceModesInteractor() }.shared
    }
    
    var aerospaceModesRepository: Factory<any AerospaceModesRepository> {
        self { self.aerospaceModesInteractor() }.shared
    }
    
    var aerospaceModeSwitcher: Factory<any AerospaceModeSwitcher> {
        self { self.aerospaceModesInteractor() }.shared
    }
    
    var aerospaceInteractor: Factory<AerospaceInteractor> {
        self { AerospaceInteractor() }
    }
    
    // MARK: -
    
    var widgetsManager: Factory<WidgetsRepository> {
        self { WidgetsRepository() }.shared
    }
    
    var storageDevicesMonitor: Factory<StorageDevicesMonitor> {
        self { StorageDevicesMonitor() }.shared
    }
}

