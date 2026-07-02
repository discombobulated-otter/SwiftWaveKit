//
//  WaveModifiers.swift
//  WaveKit
//
//  SwiftUI-style view modifiers for customizing WaveView.
//  These inject values through the Environment, read by WaveView internally.
//

import SwiftUI

// MARK: - View Modifiers

extension View {

    /// Sets the amplitude (vertical scale) of the wave.
    ///
    /// - Parameter value: The amplitude multiplier. Default is `1.0`.
    /// - Returns: A modified view.
    public func amplitude(_ value: Double) -> some View {
        environment(\.waveAmplitude, value)
    }

    /// Sets the frequency (horizontal scale) of the wave.
    ///
    /// - Parameter value: The frequency multiplier. Default is `1.0`.
    /// - Returns: A modified view.
    public func frequency(_ value: Double) -> some View {
        environment(\.waveFrequency, value)
    }

    /// Sets the phase offset of the wave.
    ///
    /// - Parameter value: The phase offset in radians. Default is `0`.
    /// - Returns: A modified view.
    public func phase(_ value: Double) -> some View {
        environment(\.wavePhase, value)
    }

    /// Sets the x-range over which the wave function is evaluated.
    ///
    /// - Parameter range: A closed range of x values. Default is `0...2π`.
    /// - Returns: A modified view.
    public func xRange(_ range: ClosedRange<Double>) -> some View {
        environment(\.waveXRange, range)
    }

    /// Sets the number of sample points used to render the wave.
    ///
    /// Higher values produce smoother curves at the cost of performance.
    ///
    /// - Parameter count: Number of samples. Default is `200`.
    /// - Returns: A modified view.
    public func sampleCount(_ count: Int) -> some View {
        environment(\.waveSampleCount, count)
    }

    /// Sets the stroke color of the wave.
    ///
    /// - Parameter color: The stroke color. Default is `.primary`.
    /// - Returns: A modified view.
    public func waveColor(_ color: Color) -> some View {
        environment(\.waveStrokeColor, color)
    }

    /// Sets the line width of the wave stroke.
    ///
    /// - Parameter width: The line width. Default is `2.0`.
    /// - Returns: A modified view.
    public func waveLineWidth(_ width: CGFloat) -> some View {
        environment(\.waveLineWidth, width)
    }

    /// Applies a gradient to the wave stroke.
    ///
    /// ```swift
    /// WaveView(.sine)
    ///     .gradient(.linear, colors: [.blue, .purple])
    /// ```
    ///
    /// - Parameters:
    ///   - style: The gradient style (`.linear`, `.radial`, or `.angular`).
    ///   - colors: The gradient colors.
    ///   - direction: The gradient direction (used for `.linear` style). Default is `.vertical`.
    /// - Returns: A modified view.
    public func gradient(
        _ style: WaveGradientStyle,
        colors: [Color],
        direction: WaveGradientDirection = .vertical
    ) -> some View {
        let waveGrad = WaveGradient(
            gradient: Gradient(colors: colors),
            style: style,
            direction: direction
        )
        return environment(\.waveGradient, waveGrad)
    }

    /// Sets the gradient direction for the wave.
    ///
    /// Only takes effect if a gradient has already been set via `.gradient(...)`.
    ///
    /// - Parameter direction: `.horizontal` or `.vertical`.
    /// - Returns: A modified view.
    public func gradientDirection(_ direction: WaveGradientDirection) -> some View {
        transformEnvironment(\.waveGradient) { gradient in
            gradient?.direction = direction
        }
    }

    /// Sets the vertical offset of the wave within its frame.
    ///
    /// - Parameter offset: The offset in amplitude units. Default is `0`.
    /// - Returns: A modified view.
    public func verticalOffset(_ offset: Double) -> some View {
        environment(\.waveVerticalOffset, offset)
    }

    /// Enables or disables continuous wave animation.
    ///
    /// When enabled, the wave's phase continuously shifts to create
    /// a traveling wave effect.
    ///
    /// - Parameter enabled: Whether animation is enabled. Default is `true`.
    /// - Returns: A modified view.
    public func animated(_ enabled: Bool = true) -> some View {
        environment(\.waveAnimated, enabled)
    }

    /// Sets the animation speed of the wave.
    ///
    /// - Parameter speed: The speed multiplier. Default is `1.0`. Higher values = faster animation.
    /// - Returns: A modified view.
    public func animationSpeed(_ speed: Double) -> some View {
        environment(\.waveAnimationSpeed, speed)
    }
    
    /// Sets the rendering mode to 3D.
    public func renderMode3D(_ enabled: Bool = true) -> some View {
        environment(\.waveRenderMode, enabled ? .threeDimensional : .twoDimensional)
    }

    /// Sets the progress length of the wave along the Z-axis (0.0 to 1.0).
    public func progress(_ value: Double) -> some View {
        environment(\.waveProgress, value)
    }

    /// Shows or hides the target matching wave for comparison.
    public func showInterference(_ enabled: Bool) -> some View {
        environment(\.waveShowInterference, enabled)
    }

    /// Animates the alignment (transitioning target and user wave overlap).
    public func isAligning(_ enabled: Bool) -> some View {
        environment(\.waveIsAligning, enabled)
    }

    /// Sets the amplitude of the target matching wave.
    public func targetAmplitude(_ value: Double) -> some View {
        environment(\.waveTargetAmplitude, value)
    }

    /// Sets the frequency of the target matching wave.
    public func targetFrequency(_ value: Double) -> some View {
        environment(\.waveTargetFrequency, value)
    }

    /// Sets the phase of the target matching wave.
    public func targetPhase(_ value: Double) -> some View {
        environment(\.waveTargetPhase, value)
    }

    /// Sets the color of the target matching wave.
    public func targetColor(_ color: Color) -> some View {
        environment(\.waveTargetColor, color)
    }

    /// Sets a custom target function for the comparison wave.
    public func targetFunction(_ function: WaveFunction) -> some View {
        environment(\.waveTargetFunction, function)
    }

    /// Toggles pure tone rendering mode (removes secondary frequencies).
    public func isPureTone(_ enabled: Bool) -> some View {
        environment(\.waveIsPureTone, enabled)
    }

    /// Toggles ECG heartbeat rendering mode.
    public func isECG(_ enabled: Bool) -> some View {
        environment(\.waveIsECG, enabled)
    }
}
