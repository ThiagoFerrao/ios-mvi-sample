// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum GenString {

  internal enum AppDelegate {
    internal enum UISceneConfiguration {
      /// Default Configuration
      internal static let `default` = GenString.tr("Base", "AppDelegate.UISceneConfiguration.default")
    }
  }

  internal enum Development {
    internal enum Assertion {
      /// init has not been implemented
      internal static let initUnimplemented = GenString.tr("Base", "Development.Assertion.initUnimplemented")
      /// This method must be overridden
      internal static let mustOverrideMethod = GenString.tr("Base", "Development.Assertion.mustOverrideMethod")
    }
  }

  internal enum Network {
    internal enum Header {
      /// Accept
      internal static let acceptKey = GenString.tr("Base", "Network.Header.acceptKey")
      /// application/json
      internal static let acceptValue = GenString.tr("Base", "Network.Header.acceptValue")
      /// user-key
      internal static let userKey = GenString.tr("Base", "Network.Header.userKey")
      /// 
      internal static let userValue = GenString.tr("Base", "Network.Header.userValue")
    }
    internal enum Request {
      /// 
      internal static let domain = GenString.tr("Base", "Network.Request.domain")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension GenString {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
