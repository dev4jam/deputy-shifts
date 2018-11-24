// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Loading...
  internal static let loading = L10n.tr("Localizable", "Loading")
  /// LocationDisabled
  internal static let locationDisabled = L10n.tr("Localizable", "LocationDisabled")
  /// Location is not authorised
  internal static let locationNotAuthorised = L10n.tr("Localizable", "LocationNotAuthorised")
  /// Location not found
  internal static let locationNotFound = L10n.tr("Localizable", "LocationNotFound")
  /// N/A
  internal static let notAvailable = L10n.tr("Localizable", "NotAvailable")
  /// Shift
  internal static let shift = L10n.tr("Localizable", "Shift")
  /// Shifts
  internal static let shifts = L10n.tr("Localizable", "Shifts")
  /// Start
  internal static let start = L10n.tr("Localizable", "Start")
  /// Stop
  internal static let stop = L10n.tr("Localizable", "Stop")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

