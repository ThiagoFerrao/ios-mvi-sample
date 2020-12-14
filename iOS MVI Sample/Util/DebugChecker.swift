import Foundation

final class DebugChecker {
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
