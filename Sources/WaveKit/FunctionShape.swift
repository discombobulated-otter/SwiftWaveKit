//
//  FunctionShape.swift
//  WaveKit
//
//  The core rendering engine — a SwiftUI Shape that converts mathematical
//  function output into a drawable Path. Conforms to Shape so all standard
//  SwiftUI modifiers (.stroke, .fill, .trim) work natively.
//

import SwiftUI

/// A SwiftUI `Shape` that renders a mathematical function as a smooth curve.
///
/// `FunctionShape` samples the provided `WaveFunction` across a configurable
/// x-range and maps the results into screen coordinates, producing a `Path`
/// suitable for stroking or filling.
///
/// ```swift
/// FunctionShape(function: .sine)
///     .stroke(.blue, lineWidth: 2)
///     .frame(height: 200)
/// ```
public struct FunctionShape: Shape, @unchecked Sendable {

    /// The mathematical function to render.
    public var function: WaveFunction

    /// Phase offset applied to the function input: `f(frequency * x + phase)`.
    public var phase: Double

    /// Vertical scaling factor for the function output.
    public var amplitude: Double

    /// Horizontal scaling factor for the function input.
    public var frequency: Double

    /// Number of sample points used to approximate the curve.
    /// Higher values produce smoother curves at the cost of performance.
    public var sampleCount: Int

    /// The mathematical x-range over which the function is evaluated.
    public var xRange: ClosedRange<Double>

    /// Vertical offset in the normalized coordinate space (0 = center).
    public var verticalOffset: Double

    /// Creates a new `FunctionShape`.
    ///
    /// - Parameters:
    ///   - function: The mathematical function to render.
    ///   - phase: Phase offset. Default is `0`.
    ///   - amplitude: Vertical scale. Default is `1.0`.
    ///   - frequency: Horizontal scale. Default is `1.0`.
    ///   - sampleCount: Number of sample points. Default is `200`.
    ///   - xRange: The x-domain to render. Default is `0...2π`.
    ///   - verticalOffset: Vertical shift. Default is `0`.
    public init(
        function: WaveFunction,
        phase: Double = 0,
        amplitude: Double = 1.0,
        frequency: Double = 1.0,
        sampleCount: Int = 200,
        xRange: ClosedRange<Double> = 0...(2 * .pi),
        verticalOffset: Double = 0
    ) {
        self.function = function
        self.phase = phase
        self.amplitude = amplitude
        self.frequency = frequency
        self.sampleCount = sampleCount
        self.xRange = xRange
        self.verticalOffset = verticalOffset
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let rangeWidth = xRange.upperBound - xRange.lowerBound
        guard rangeWidth > 0, sampleCount > 1 else { return path }

        let step = rangeWidth / Double(sampleCount - 1)

        // We need to determine vertical scale. We map amplitude = 1.0 to
        // fill roughly 40% of the available half-height, matching the
        // WaveQuestApp's yScale approach.
        let halfHeight = rect.height / 2.0
        let verticalScale = halfHeight * 0.8 // 80% of half-height per unit amplitude

        var previousY: Double?
        var isFirstValidPoint = true
        // Threshold for detecting discontinuities (e.g. tan(x) near π/2)
        let discontinuityThreshold = rect.height * 0.5

        for i in 0..<sampleCount {
            let x = xRange.lowerBound + Double(i) * step
            let input = frequency * x + phase
            let rawY = function.evaluate(input)

            // Skip NaN/Infinity (protection for functions like tan)
            guard rawY.isFinite else {
                isFirstValidPoint = true
                previousY = nil
                continue
            }

            let y = amplitude * rawY

            // Map to screen coordinates:
            // screenX: linear mapping from xRange to rect width
            // screenY: center of rect - y * scale (inverted because screen Y grows downward)
            let screenX = rect.minX + (x - xRange.lowerBound) / rangeWidth * rect.width
            let screenY = rect.midY - y * verticalScale + verticalOffset * verticalScale

            // Detect discontinuities
            if let prevY = previousY {
                let delta = abs(screenY - prevY)
                if delta > discontinuityThreshold {
                    // Start a new sub-path at this point
                    path.move(to: CGPoint(x: screenX, y: screenY))
                    previousY = screenY
                    continue
                }
            }

            if isFirstValidPoint {
                path.move(to: CGPoint(x: screenX, y: screenY))
                isFirstValidPoint = false
            } else {
                path.addLine(to: CGPoint(x: screenX, y: screenY))
            }

            previousY = screenY
        }

        return path
    }
}

// MARK: - Animatable

extension FunctionShape: Animatable {
    /// The phase value is animatable, enabling smooth wave animation
    /// when driven by SwiftUI's animation system or `TimelineView`.
    public var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
}
