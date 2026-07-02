//
//  WaveView.swift
//  WaveKit
//
//  The main public-facing View for rendering waves.
//  Supports both closure-based and preset-based initialization.
//

import SwiftUI

/// A SwiftUI view that renders a mathematical wave function.
///
/// `WaveView` is the primary public API of WaveKit. It supports two
/// initialization styles:
///
/// **Closure API** — render any function:
/// ```swift
/// WaveView { x in sin(x) }
/// ```
///
/// **Preset API** — use a built-in waveform:
/// ```swift
/// WaveView(.sine)
/// ```
///
/// Customize with SwiftUI-style modifiers:
/// ```swift
/// WaveView(.sine)
///     .amplitude(1.5)
///     .frequency(2.0)
///     .waveColor(.blue)
///     .animated(true)
///     .animationSpeed(1.2)
/// ```
///
/// `WaveView` internally uses `FunctionShape`, which conforms to `Shape`,
/// so standard SwiftUI shape modifiers like `.stroke()`, `.fill()`, and `.trim()`
/// also work when you use `FunctionShape` directly.
public struct WaveView: View {

    private let function: WaveFunction

    // MARK: - Environment

    @Environment(\.waveAmplitude) private var amplitude
    @Environment(\.waveFrequency) private var frequency
    @Environment(\.wavePhase) private var basePhase
    @Environment(\.waveXRange) private var xRange
    @Environment(\.waveSampleCount) private var sampleCount
    @Environment(\.waveLineWidth) private var lineWidth
    @Environment(\.waveStrokeColor) private var strokeColor
    @Environment(\.waveGradient) private var waveGradient
    @Environment(\.waveVerticalOffset) private var verticalOffset
    @Environment(\.waveAnimated) private var isAnimated
    @Environment(\.waveAnimationSpeed) private var animationSpeed
    @Environment(\.waveRenderMode) private var renderMode

    // MARK: - Init

    /// Creates a `WaveView` from a built-in preset.
    ///
    /// ```swift
    /// WaveView(.sine)
    /// WaveView(.damped)
    /// WaveView(.gaussian)
    /// ```
    ///
    /// - Parameter preset: A `WaveFunction` preset (e.g., `.sine`, `.cosine`).
    public init(_ preset: WaveFunction) {
        self.function = preset
    }

    /// Creates a `WaveView` from a custom closure.
    ///
    /// ```swift
    /// WaveView { x in
    ///     exp(-0.2 * x) * sin(5 * x)
    /// }
    /// ```
    ///
    /// - Parameter function: A closure mapping `Double → Double`.
    public init(_ function: @Sendable @escaping (Double) -> Double) {
        self.function = WaveFunction(function)
    }

    // MARK: - Body

    public var body: some View {
        if renderMode == .threeDimensional {
            WaveVisualizer3D(function: function)
        } else {
            if isAnimated {
                AnimatedWaveContent(
                    function: function,
                    amplitude: amplitude,
                    frequency: frequency,
                    basePhase: basePhase,
                    xRange: xRange,
                    sampleCount: sampleCount,
                    lineWidth: lineWidth,
                    strokeColor: strokeColor,
                    waveGradient: waveGradient,
                    verticalOffset: verticalOffset,
                    animationSpeed: animationSpeed
                )
            } else {
                staticWaveContent(phase: basePhase)
            }
        }
    }

    // MARK: - Static Rendering

    @ViewBuilder
    private func staticWaveContent(phase: Double) -> some View {
        let shape = FunctionShape(
            function: function,
            phase: phase,
            amplitude: amplitude,
            frequency: frequency,
            sampleCount: sampleCount,
            xRange: xRange,
            verticalOffset: verticalOffset
        )

        if let waveGrad = waveGradient {
            shape.stroke(
                gradientShapeStyle(for: waveGrad),
                lineWidth: lineWidth
            )
        } else {
            shape.stroke(strokeColor, lineWidth: lineWidth)
        }
    }

    /// Converts a `WaveGradient` configuration into a SwiftUI `ShapeStyle`.
    private func gradientShapeStyle(for config: WaveGradient) -> some ShapeStyle {
        switch config.style {
        case .linear:
            let start: UnitPoint = config.direction == .horizontal ? .leading : .top
            let end: UnitPoint = config.direction == .horizontal ? .trailing : .bottom
            return AnyShapeStyle(
                LinearGradient(
                    gradient: config.gradient,
                    startPoint: start,
                    endPoint: end
                )
            )
        case .radial:
            return AnyShapeStyle(
                RadialGradient(
                    gradient: config.gradient,
                    center: .center,
                    startRadius: 0,
                    endRadius: 200
                )
            )
        case .angular:
            return AnyShapeStyle(
                AngularGradient(
                    gradient: config.gradient,
                    center: .center
                )
            )
        }
    }
}

// MARK: - Animated Wave Content (TimelineView-based)

/// Internal view that drives continuous phase animation using `TimelineView`.
///
/// This follows the same animation philosophy as WaveQuestApp's 3D wave renderers:
/// continuous phase shift creating a traveling wave effect, synchronized to the
/// display refresh rate.
struct AnimatedWaveContent: View {
    let function: WaveFunction
    let amplitude: Double
    let frequency: Double
    let basePhase: Double
    let xRange: ClosedRange<Double>
    let sampleCount: Int
    let lineWidth: CGFloat
    let strokeColor: Color
    let waveGradient: WaveGradient?
    let verticalOffset: Double
    let animationSpeed: Double

    let startDate = Date.now

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            // Phase increases with time to create traveling wave effect.
            // Speed of 1.0 ≈ one full cycle per ~6.28 seconds (2π seconds).
            let animatedPhase = basePhase + elapsed * animationSpeed

            let shape = FunctionShape(
                function: function,
                phase: animatedPhase,
                amplitude: amplitude,
                frequency: frequency,
                sampleCount: sampleCount,
                xRange: xRange,
                verticalOffset: verticalOffset
            )

            if let waveGrad = waveGradient {
                shape.stroke(
                    gradientStyle(for: waveGrad),
                    lineWidth: lineWidth
                )
            } else {
                shape.stroke(strokeColor, lineWidth: lineWidth)
            }
        }
    }

    private func gradientStyle(for config: WaveGradient) -> some ShapeStyle {
        switch config.style {
        case .linear:
            let start: UnitPoint = config.direction == .horizontal ? .leading : .top
            let end: UnitPoint = config.direction == .horizontal ? .trailing : .bottom
            return AnyShapeStyle(
                LinearGradient(
                    gradient: config.gradient,
                    startPoint: start,
                    endPoint: end
                )
            )
        case .radial:
            return AnyShapeStyle(
                RadialGradient(
                    gradient: config.gradient,
                    center: .center,
                    startRadius: 0,
                    endRadius: 200
                )
            )
        case .angular:
            return AnyShapeStyle(
                AngularGradient(
                    gradient: config.gradient,
                    center: .center
                )
            )
        }
    }
}
