import Foundation

final class AppChecker {
    static var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment[GenString.Development.Test.Path.environment] != nil
    }

    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static func executeInDebug(handler: (() -> Void)) {
        if isDebug {
            handler()
        }
    }
}
