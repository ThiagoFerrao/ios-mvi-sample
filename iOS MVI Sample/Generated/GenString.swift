// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum GenString {

  internal enum Alert {
    internal enum Action {
      /// Close
      internal static let close = GenString.tr("Base", "Alert.Action.close")
      /// Retry
      internal static let retry = GenString.tr("Base", "Alert.Action.retry")
    }
    internal enum Message {
      /// An error during the data request happened. \nPlease, try again later
      internal static let defaultError = GenString.tr("Base", "Alert.Message.defaultError")
      /// Cannot find the restaurant that you are searching for
      internal static let emptyResponse = GenString.tr("Base", "Alert.Message.emptyResponse")
      /// An user Key is needed to use the Zomato API. \nGenerate one in the Zomato website and add it in the Base.strings before running the app
      internal static let userKeyError = GenString.tr("Base", "Alert.Message.userKeyError")
    }
    internal enum Title {
      /// No results found
      internal static let emptyResponse = GenString.tr("Base", "Alert.Title.emptyResponse")
      /// Unable to Retrieve Data
      internal static let error = GenString.tr("Base", "Alert.Title.error")
    }
  }

  internal enum AppDelegate {
    internal enum UISceneConfiguration {
      /// Default Configuration
      internal static let `default` = GenString.tr("Base", "AppDelegate.UISceneConfiguration.default")
    }
  }

  internal enum Development {
    internal enum Assertion {
      /// Unable to retrive file data inside bundle
      internal static let bundleFileNotFound = GenString.tr("Base", "Development.Assertion.bundleFileNotFound")
      /// init has not been implemented
      internal static let initUnimplemented = GenString.tr("Base", "Development.Assertion.initUnimplemented")
      /// This method must be overridden
      internal static let mustOverrideMethod = GenString.tr("Base", "Development.Assertion.mustOverrideMethod")
    }
    internal enum Test {
      internal enum Path {
        /// XCTestConfigurationFilePath
        internal static let environment = GenString.tr("Base", "Development.Test.Path.environment")
      }
    }
  }

  internal enum Home {
    internal enum Collection {
      internal enum DefaultCell {
        /// HomeCollectionDefaultCell
        internal static let identifier = GenString.tr("Base", "Home.Collection.DefaultCell.identifier")
      }
    }
    internal enum Request {
      internal enum Parameter {
        /// q
        internal static let search = GenString.tr("Base", "Home.Request.Parameter.search")
      }
      internal enum Path {
        /// categories
        internal static let categories = GenString.tr("Base", "Home.Request.Path.categories")
        /// search
        internal static let search = GenString.tr("Base", "Home.Request.Path.search")
      }
    }
    internal enum View {
      /// Search for restaurant, cuisine or a dish
      internal static let searchPlaceholder = GenString.tr("Base", "Home.View.searchPlaceholder")
      /// List of Restaurants
      internal static let title = GenString.tr("Base", "Home.View.title")
    }
  }

  internal enum Network {
    /// https://developers.zomato.com/api
    internal static let domain = GenString.tr("Base", "Network.domain")
    /// v2.1
    internal static let version = GenString.tr("Base", "Network.version")
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
