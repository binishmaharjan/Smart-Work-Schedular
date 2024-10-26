import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/* TODO: Not Working
    @sharedPeer(Int) @sharedAccessor
    var displayMode: DisplayMode = .month
 
    Expected Result
    var displayMode: DisplayMode {
    get { DisplayMode(rawValue: _displayMode) ?? DisplayMode.allCase[0] }
    set { _displayMode = newValue.rawValue }
    }
    var _displayMode: Int = DisplayMode.month.rawValue
    */

// AccessorMacro + PeerMacro
public struct SharedAccessor: AccessorMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration:
        some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        guard let variable = declaration.as(VariableDeclSyntax.self) else {
            throw AsyncDeclError.onlyApplicableToVariable
        }
        
        guard let binding = variable.bindings.first else {
            throw AsyncDeclError.missingProperties
        }
        
        guard
            let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
            let typeAnnotation = binding.typeAnnotation,
            binding.initializer != nil
        else {
            throw AsyncDeclError.missingProperties
        }
        
        let name = pattern.identifier.text
        let variableType = typeAnnotation.type.description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return [
            AccessorDeclSyntax(
                stringLiteral: """
                    get { \(variableType)(rawValue: _\(name)) ?? \(variableType).allCases[0] }
                    set { _\(name) = newValue.rawValue }
                """
            )
        ]
    }
}

// swiftlint:disable:next file_types_order
public struct SharedPeer: PeerMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let variable = declaration.as(VariableDeclSyntax.self) else {
            throw AsyncDeclError.onlyApplicableToVariable
        }
        
        guard let argument = node.arguments else {
            throw AsyncDeclError.noArguments
        }
        
        guard let binding = variable.bindings.first else {
            throw AsyncDeclError.missingProperties
        }
        
        guard
            let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
            let typeAnnotation = binding.typeAnnotation,
            let initializer = binding.initializer
        else {
            throw AsyncDeclError.missingProperties
        }
        
        let name = pattern.identifier.text
        let variableType = typeAnnotation.type.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let value = initializer.value.description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return [
            DeclSyntax(
            """
                var _\(raw: name): \(raw: argument.description) = \(raw: variableType)\(raw: value).rawValue
            """
            )
        ]
    }
}

public enum AsyncDeclError: CustomStringConvertible, Error {
    case onlyApplicableToVariable
    case noArguments
    case missingProperties

    public var description: String {
        switch self {
        case .onlyApplicableToVariable:
            "@macro can only be applied to a variable."
            
        case .noArguments:
            "@macro has no argument."
            
        case .missingProperties:
            "@macro has missing properties."
        }
    }
}
