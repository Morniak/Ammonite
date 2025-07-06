//
//  SetWidget.swift
//  AmmoniteCLI
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation
import ArgumentParser

extension Widget: ExpressibleByArgument { }
extension WidgetPosition: ExpressibleByArgument { }

struct SetWidget: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Set widget(s) on a specific position.")

    @Argument(help: "The widget(s) position")
    var position: WidgetPosition
    
    @Argument(help: "The list of widgets to set")
    var widgets: [Widget]
    
    func run() throws {
        if (position == .leftNotch || position == .rightNotch) && widgets.count > 1 {
            throw ValidationError("Only one widget can be set on each side of the notch")
        }
        try postCommandNotification(command: .widget(position, widgets))
    }
}
