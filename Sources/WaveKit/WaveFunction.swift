//
//  WaveFunction.swift
//  WaveKit
//
//  A mathematical function mapping x → y.
//  This is the foundational type that everything in WaveKit builds on.
//

import Foundation

/// A mathematical function that maps an input value to an output value.
///
/// `WaveFunction` wraps a `@Sendable` closure, making it safe to use
/// across concurrency boundaries in Swift 6.
///
/// ```swift
/// let myWave = WaveFunction { x in sin(x) }
/// let y = myWave.evaluate(Double.pi / 2) // 1.0
/// ```
public struct WaveFunction: Sendable {

    /// The underlying mathematical function.
    public let evaluate: @Sendable (Double) -> Double

    /// Creates a wave function from a closure.
    ///
    /// - Parameter evaluate: A closure that takes a `Double` input and returns a `Double` output.
    public init(_ evaluate: @Sendable @escaping (Double) -> Double) {
        self.evaluate = evaluate
    }
}

// MARK: - Function Composition

extension WaveFunction {

    /// Adds two wave functions together, producing a new function whose output
    /// is the sum of both at any given x.
    ///
    /// ```swift
    /// let combined = .sine + .cosine
    /// ```
    public static func + (lhs: WaveFunction, rhs: WaveFunction) -> WaveFunction {
        WaveFunction { x in lhs.evaluate(x) + rhs.evaluate(x) }
    }

    /// Subtracts one wave function from another.
    public static func - (lhs: WaveFunction, rhs: WaveFunction) -> WaveFunction {
        WaveFunction { x in lhs.evaluate(x) - rhs.evaluate(x) }
    }

    /// Multiplies two wave functions together (amplitude modulation).
    public static func * (lhs: WaveFunction, rhs: WaveFunction) -> WaveFunction {
        WaveFunction { x in lhs.evaluate(x) * rhs.evaluate(x) }
    }

    /// Scales a wave function by a constant factor.
    public static func * (lhs: Double, rhs: WaveFunction) -> WaveFunction {
        WaveFunction { x in lhs * rhs.evaluate(x) }
    }

    /// Scales a wave function by a constant factor.
    public static func * (lhs: WaveFunction, rhs: Double) -> WaveFunction {
        WaveFunction { x in lhs.evaluate(x) * rhs }
    }
}
