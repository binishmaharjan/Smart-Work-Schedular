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
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.debug("[\(fileName): \(parameters.line)] \(parameters.message)")
            },
            info: { parameters in
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.info("[\(fileName): \(parameters.line)] \(parameters.message)")
            },
            warning: { parameters in
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.warning("[\(fileName): \(parameters.line)] \(parameters.message)")
            },
            error: { parameters in
                let fileName = (parameters.file as NSString).lastPathComponent
                logger.error("[\(fileName): \(parameters.line)] \(parameters.message)")
            }
        )
    }
}

