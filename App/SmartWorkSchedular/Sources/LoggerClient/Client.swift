import Dependencies
import Foundation
import os.log

public struct LoggerClient {
    internal static var isLogEnabled = false
    internal static var logLevel: LogLevel = .error
    
    public var debug: (LoggerParameter) -> Void
    public var info: (LoggerParameter) -> Void
    public var warning: (LoggerParameter) -> Void
    public var error: (LoggerParameter) -> Void
}

// MARK: Helpers (Creating methods for passing #file and #line)
extension LoggerClient {
    /// If Disabled, will not be printed
    public func setLogEnabled(_ isEnabled: Bool) {
        Self.isLogEnabled = isEnabled
    }
    
    /// Log with the smaller level will be ignored and not printed
    public func setLogLevel(_ logLevel: LogLevel) {
        Self.logLevel = logLevel
    }
    
    /// Print debug log
    public func debug(file: String = #file, line: Int = #line, _ message: String) {
        let parameters = LoggerParameter(file: file, line: line, message)
        self.debug(parameters)
    }
    
    /// Print info log
    public func info(_ message: String, file: String = #file, line: Int = #line) {
        let parameters = LoggerParameter(file: file, line: line, message)
        self.info(parameters)
    }
    
    /// Print warning log
    public func warning(_ message: String, file: String = #file, line: Int = #line) {
        let parameters = LoggerParameter(file: file, line: line, message)
        self.warning(parameters)
    }
    
    /// Print error log
    public func error(_ message: String, file: String = #file, line: Int = #line) {
        let parameters = LoggerParameter(file: file, line: line, message)
        self.error(parameters)
    }
}

// MARK: DependencyValues
extension DependencyValues {
    public var loggerClient: LoggerClient {
        get { self[LoggerClient.self] }
        set { self[LoggerClient.self] = newValue }
    }
}

// MARK: Dependecy (testValue, previewValue)
extension LoggerClient: TestDependencyKey {
    public static var testValue = LoggerClient(
        debug:  unimplemented("\(Self.self).debug is unimplemented", placeholder: ()),
        info:  unimplemented("\(Self.self).info is unimplemented", placeholder: ()),
        warning:  unimplemented("\(Self.self).warning is unimplemented", placeholder: ()),
        error:  unimplemented("\(Self.self).error is unimplemented", placeholder: ())
    )
    
    public static var previewValue = LoggerClient(
        debug:  unimplemented("\(Self.self).debug is unimplemented", placeholder: ()),
        info:  unimplemented("\(Self.self).info is unimplemented", placeholder: ()),
        warning:  unimplemented("\(Self.self).warning is unimplemented", placeholder: ()),
        error:  unimplemented("\(Self.self).error is unimplemented", placeholder: ())
    )
}
