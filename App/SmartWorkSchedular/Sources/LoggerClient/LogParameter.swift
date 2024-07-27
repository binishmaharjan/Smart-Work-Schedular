import Foundation

public struct LoggerParameter {
    public init(file: String = #file, line: Int = #line, _ message: String) {
        self.file = file
        self.line = line
        self.message = message
    }
    
    public var file: String
    public var line: Int
    public var message: String
}
