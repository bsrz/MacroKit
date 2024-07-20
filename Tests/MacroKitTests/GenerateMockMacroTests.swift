import MacroKitMacros
import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

private let testMacros: [String: Macro.Type] = [
    "GenerateMock": GenerateMockMacro.self,
]

// edges cases:
//  - overloaded functions

class GenerateMockMacroTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(macros: [GenerateMockMacro.self]) {
            super.invokeTest()
        }
    }

    func testGenerateMock_HappyPath_SimpleProperty() {
        let proto = """
        protocol TestProtocol {
            var property: String {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: String {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<String, String> = .init()
                }
                public init() {
                }
                open var property: String {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ThrowingProperty() {
        let proto = """
        protocol TestProtocol {
            var property: String {
                get throws
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: String {
                    get throws
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<String, Result<String, Error>> = .init()
                }
                public init() {
                }
                open var property: String {
                    get throws {
                        try mocks.property.getter()
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_AsyncProperty() {
        let proto = """
        protocol TestProtocol {
            var property: String {
                get async
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: String {
                    get async
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<String, String> = .init()
                }
                public init() {
                }
                open var property: String {
                    get async {
                        mocks.property.getter()
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_AsyncThrowingProperty() {
        let proto = """
        protocol TestProtocol {
            var property: String {
                get async throws
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: String {
                    get async throws
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<String, Result<String, Error>> = .init()
                }
                public init() {
                }
                open var property: String {
                    get async throws {
                        try mocks.property.getter()
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_SimpleProperty_GetSet() {
        let proto = """
        protocol TestProtocol {
            var property: String {
                get
                set
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: String {
                    get
                    set
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<String, String> = .init()
                }
                public init() {
                }
                open var property: String {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_ClosureProperty_Void() {
        let proto = """
        protocol TestProtocol {
            var property: () -> Void {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: () -> Void {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<() -> Void, () -> Void> = .init()
                }
                public init() {
                }
                open var property: () -> Void {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ClosureProperty_OneParam() {
        let proto = """
        protocol TestProtocol {
            var property: (Int) -> Void {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: (Int) -> Void {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<(Int) -> Void, (Int) -> Void> = .init()
                }
                public init() {
                }
                open var property: (Int) -> Void {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ClosureProperty_TwoParam() {
        let proto = """
        protocol TestProtocol {
            var property: (Int, Bool) -> Void {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: (Int, Bool) -> Void {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<(Int, Bool) -> Void, (Int, Bool) -> Void> = .init()
                }
                public init() {
                }
                open var property: (Int, Bool) -> Void {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_ThrowingClosureProperty_TwoParam() {
        let proto = """
        protocol TestProtocol {
            var property: (Int, Bool) throws -> Void {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: (Int, Bool) throws -> Void {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<(Int, Bool) throws -> Void, (Int, Bool) throws -> Void> = .init()
                }
                public init() {
                }
                open var property: (Int, Bool) throws -> Void {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ThrowingAsyncClosureProperty_TwoParam() {
        let proto = """
        protocol TestProtocol {
            var property: (Int, Bool) async throws -> Void {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                var property: (Int, Bool) async throws -> Void {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<(Int, Bool) async throws -> Void, (Int, Bool) async throws -> Void> = .init()
                }
                public init() {
                }
                open var property: (Int, Bool) async throws -> Void {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_ImplicitVoidFunction() {
        let proto = """
        protocol TestProtocol {
            func function()
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function()
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(), Void> = .init()
                }
                public init() {
                }
                open func function() {
                    return mocks.function.execute(())
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ExplicitVoidFunction() {
        let proto = """
        protocol TestProtocol {
            func function() -> Void
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function() -> Void
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(), Void> = .init()
                }
                public init() {
                }
                open func function() -> Void {
                    return mocks.function.execute(())
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ImplicitVoidFunction_WithParam() {
        let proto = """
        protocol TestProtocol {
            func function(value: Int)
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(value: Int)
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(Int), Void> = .init()
                }
                public init() {
                }
                open func function(value arg0: Int) {
                    return mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ExplicitVoidFunction_WithParam() {
        let proto = """
        protocol TestProtocol {
            func function(value: Int) -> Void
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(value: Int) -> Void
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(Int), Void> = .init()
                }
                public init() {
                }
                open func function(value arg0: Int) -> Void {
                    return mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_NonVoidFunction_WithAnonParam() {
        let proto = """
        protocol TestProtocol {
            func function(_ value: Int) -> Bool
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(_ value: Int) -> Bool
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(Int), Bool> = .init()
                }
                public init() {
                }
                open func function(_ arg0: Int) -> Bool {
                    return mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_NonVoidFunction_WithInternalAndExternalParams() {
        let proto = """
        protocol TestProtocol {
            func function(with value: Int) -> Bool
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(with value: Int) -> Bool
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(Int), Bool> = .init()
                }
                public init() {
                }
                open func function(with arg0: Int) -> Bool {
                    return mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_ClosureFunction_WithAnonParam() {
        let proto = """
        protocol TestProtocol {
            func function(_ value: Int) -> () -> Void
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(_ value: Int) -> () -> Void
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(Int), () -> Void> = .init()
                }
                public init() {
                }
                open func function(_ arg0: Int) -> () -> Void {
                    return mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_ClosureFunctionWithParam_WithAnonParam() {
        let proto = """
        protocol TestProtocol {
            func function(_ value: Int) -> (Bool) -> Void
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(_ value: Int) -> (Bool) -> Void
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(Int), (Bool) -> Void> = .init()
                }
                public init() {
                }
                open func function(_ arg0: Int) -> (Bool) -> Void {
                    return mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_ThrowingFunction() {
        let proto = """
        protocol TestProtocol {
            func function() throws
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function() throws
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(), Result<Void, Error>> = .init()
                }
                public init() {
                }
                open func function() throws {
                    return try mocks.function.execute(())
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_AsyncFunction() {
        let proto = """
        protocol TestProtocol {
            func function() async
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function() async
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(), Void> = .init()
                }
                public init() {
                }
                open func function() async {
                    return mocks.function.execute(())
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_AsyncThrowingFunction() {
        let proto = """
        protocol TestProtocol {
            func function() async throws
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function() async throws
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(), Result<Void, Error>> = .init()
                }
                public init() {
                }
                open func function() async throws {
                    return try mocks.function.execute(())
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_AsyncThrowingFunctionWithBothParamsAndReturnType() {
        let proto = """
        protocol TestProtocol {
            func function(with value: Bool) async throws -> String
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(with value: Bool) async throws -> String
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<(Bool), Result<String, Error>> = .init()
                }
                public init() {
                }
                open func function(with arg0: Bool) async throws -> String {
                    return try mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_FunctionWithParamsWithAttributes() {
        let proto = """
        protocol TestProtocol {
            func function(_ closure: @Sendable @escaping (Bool) -> Void) async throws -> String
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                func function(_ closure: @Sendable @escaping (Bool) -> Void) async throws -> String
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var function: MockMember<((Bool) -> Void), Result<String, Error>> = .init()
                }
                public init() {
                }
                open func function(_ arg0: @Sendable @escaping (Bool) -> Void) async throws -> String {
                    return try mocks.function.execute((arg0))
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_AssociatedType() {
        let proto = """
        protocol TestProtocol {
            associatedtype Value

            var property: Value {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                associatedtype Value

                var property: Value {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock<Value>: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<Value, Value> = .init()
                }
                public init() {
                }
                open var property: Value {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_AssociatedTypeWithConstraint() {
        let proto = """
        protocol TestProtocol {
            associatedtype Value: Codable

            var property: Value {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                associatedtype Value: Codable

                var property: Value {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock<Value: Codable>: TestProtocol {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<Value, Value> = .init()
                }
                public init() {
                }
                open var property: Value {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_MultipleAssociatedTypes() {
        let proto = """
        protocol TestProtocol {
            associatedtype Foo
            associatedtype Bar: Codable
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol {
                associatedtype Foo
                associatedtype Bar: Codable
            }

            #if DEBUG

            open class TestProtocolMock<Foo, Bar: Codable>: TestProtocol {
                public let mocks = Members()
                public class Members {
                }
                public init() {
                }
            }

            #endif
            """
        }
    }

    func testGenerateMock_HappyPath_Inheritance() {
        let proto = """
        protocol TestProtocol: Equatable {
            var property: String {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol: Equatable {
                var property: String {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol, Equatable {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<String, String> = .init()
                }
                public init() {
                }
                open var property: String {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }
    func testGenerateMock_HappyPath_MultipleInheritance() {
        let proto = """
        protocol TestProtocol: Equatable, Codable {
            var property: String {
                get
            }
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        } expansion: {
            """
            protocol TestProtocol: Equatable, Codable {
                var property: String {
                    get
                }
            }

            #if DEBUG

            open class TestProtocolMock: TestProtocol, Equatable, Codable {
                public let mocks = Members()
                public class Members {
                    public var property: MockMember<String, String> = .init()
                }
                public init() {
                }
                open var property: String {
                    get {
                        mocks.property.getter()
                    }
                    set {
                        mocks.property.setter(newValue)
                    }
                }
            }

            #endif
            """
        }
    }

    func _testGenerateMock_HappyPath_OverloadedFunctions() {
        let proto = """
        protocol TestProtocol {
            func function() -> String
            func function() -> Int
        }
        """
        assertMacro {
            """
            @GenerateMock
            \(proto)
            """
        }
    }
}
