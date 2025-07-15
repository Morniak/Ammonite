//
//  DefaultAmmoniteConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 24/06/2025.
//

let defaultAmmoniteConfig = """
[appearance]
    notch_width = \(AppearanceConfig.default.notchWidth)
    notch_height = \(AppearanceConfig.default.notchHeight)
    notch_corner_radius = \(AppearanceConfig.default.notchCornerRadius)

    outer_padding = \(AppearanceConfig.default.outerPadding)
    inner_padding = \(AppearanceConfig.default.innerPadding)
    items_spacing = \(AppearanceConfig.default.itemsSpacing)

    # Colors can be RGB hex, RGBA hex, or one of the following named materials:
    # \(toTOMLArray(AppearanceConfig.stringToMaterials.keys.sorted()))
    primary_color = "\(AppearanceConfig.defaultValue.primaryColor)"
    secondary_color = "\(AppearanceConfig.defaultValue.secondaryColor)"
    bar_background_color = "\(AppearanceConfig.defaultValue.barBackgroundColor)"
    menu_background_color = "\(AppearanceConfig.defaultValue.menuBackgroundColor)"

    # You can customize the font using its PostScript name.
    # This name can be found in the Font Book app’s info pane.
    # font.name = "FiraCode-Medium"
    # font.size = 12

# Available widgets:
# \(toTOMLArray(Widget.allCases.filter { $0 != .none }.map(\.rawValue)))
[widgets]
    left_bar = \(toTOMLArray(WidgetsConfig.default.leftBar.map(\.rawValue)))
    left_notch = "\(WidgetsConfig.default.leftNotch!.rawValue)"
    right_notch = "\(WidgetsConfig.default.rightNotch!.rawValue)"
    right_bar = \(toTOMLArray(WidgetsConfig.default.rightBar.map(\.rawValue)))

[workspaces]
    # Define workspace names/IDs here and/or manage them dynamically via the CLI.
    # Use workspace.current to set the initial workspace, then update it through the CLI.
    # Example:
    # workspaces = ["1", "2", ...]
    # current = "1"

    menu_display.title_style = "\(WorkspacesConfig.default.menuDisplay.titleStyle)"\t# \(toTOMLArray(WorkspaceTitleStyle.allCases.map(\.rawValue)))
    menu_display.decoration_style = "\(WorkspacesConfig.default.menuDisplay.decorationStyle)"\t# \(toTOMLArray(ItemListStyle.allCases.map(\.rawValue)))
    menu_display.show_separators = \(WorkspacesConfig.default.menuDisplay.showSeparators)

    widget_display.title_style = "\(WorkspacesConfig.default.widgetDisplay.titleStyle)"\t# \(toTOMLArray(WorkspaceTitleStyle.allCases.map(\.rawValue)))
    widget_display.decoration_style = "\(WorkspacesConfig.default.widgetDisplay.decorationStyle)"\t# \(toTOMLArray(ItemListStyle.allCases.map(\.rawValue)))
    widget_display.show_separators = \(WorkspacesConfig.default.widgetDisplay.showSeparators)

    # Use aliases to override the display names of your tiling window manager’s workspaces.
    # This is especially useful with window managers like Aerospace, which sort workspaces alphabetically.
    #
    # Example: show workspace 1 as 'web' within \(Constants.appName)
    #
    # [workspaces.aliases]
    #   1 = "web"

# If you installed Aerospace without Homebrew,
# you can manually set the path to the binary:
#
# aerospace.path = "/usr/local/bin/aerospace"

# Configuration for the widgets that show Aerospace binding modes:
[aerospace.modesWidget]
    modes = \(toTOMLArray(AerospaceConfig.default.modesWidget.modes))
    menu_style = "\(AerospaceConfig.default.modesWidget.menuStyle.rawValue)"\t#\(ItemListStyle.allCases.map(\.rawValue).joined(separator: ", "))
    show_separators_in_menu = \(AerospaceConfig.default.modesWidget.showSeparatorsInMenu)

# Assign SF Symbols to each Aerospace mode for the '\(Widget.currentAerospaceMode)' widget
[aerospace.modesWidget.icons]
    main = "\(AerospaceConfig.default.modesWidget.icons["main"]!)"
"""

private func toTOMLArray(_ array: [String]) -> String {
    let elements = array
        .map { "\"\($0)\"" }
        .joined(separator: ", ")
    return "[\(elements)]"
}
