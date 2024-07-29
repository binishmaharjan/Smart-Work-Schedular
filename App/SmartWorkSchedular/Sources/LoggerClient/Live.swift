import Foundation
import os.log
import Dependencies

// MARK: Dependency (liveValue)
extension LoggerClient: DependencyKey {
    public static var liveValue = Self.live(
        logger: Logger(subsystem: "com.binish.smartworkscheduler", category: "logger")
    )
}

// MARK: - Live Implementation
extension LoggerClient {
    private static func live(logger: os.Logger) -> Self {
        LoggerClient(
            debug: { parameters in
                guard shouldPrintLog(for: .debug) else { return }
                        
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.debug("[\(fileName): \(parameters.line)] \(parameters.message)")
            },
            info: { parameters in
                guard shouldPrintLog(for: .info) else { return }
                
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.info("[\(fileName): \(parameters.line)] \(parameters.message)")
            },
            warning: { parameters in
                guard shouldPrintLog(for: .warning) else { return }
                
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.warning("[\(fileName): \(parameters.line)] \(parameters.message)")
            },
            error: { parameters in
                guard shouldPrintLog(for: .error) else { return }
                
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.error("[\(fileName): \(parameters.line)] \(parameters.message)")
            }
        )
    }
    
    private static func shouldPrintLog(for logLevel: LogLevel) -> Bool {
        guard Self.isLogEnabled else { return false }
        
        return logLevel.rawValue >= Self.logLevel.rawValue 
    }
}

