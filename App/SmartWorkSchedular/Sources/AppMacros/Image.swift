import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct Image: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "Image(\(argument), bundle: .sharedUIs)"
    }
}
