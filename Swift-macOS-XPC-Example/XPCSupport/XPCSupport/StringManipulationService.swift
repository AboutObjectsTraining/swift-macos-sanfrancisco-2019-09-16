import Foundation

public let StringManipulationServiceName = "com.richardnees.StringManipulation"

@objc public protocol XPCStringManipulationService {
    func uppercase(_ string: String, with reply: @escaping (String) -> Void)
    func lowercase(_ string: String, with reply: @escaping (String) -> Void)
    func capitalize(_ string: String, with reply: @escaping (String) -> Void)
}
