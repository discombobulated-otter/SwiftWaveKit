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

    // MARK: - New API Combinators

    /// Sets the shape parameters of the wave (amplitude, frequency, phase).
    public func waveform(amplitude: Double = 1.0, frequency: Double = 1.0, phase: Double = 0.0) -> some View {
        self
            .environment(\.waveAmplitude, amplitude)
            .environment(\.waveFrequency, frequency)
            .environment(\.wavePhase, phase)
    }

    /// Sets the visual styling of the wave.
    public func waveStyle(_ style: WaveStyle) -> some View {
        self
            .environment(\.waveStrokeColor, style.color)
            .environment(\.waveLineWidth, style.lineWidth)
            .environment(\.waveOpacity, style.opacity)
            .environment(\.waveGlowIntensity, style.glowIntensity)
            .environment(\.waveGradient, style.gradient)
    }

    /// Sets the styling for the 3D perspective floor grid.
    public func gridStyle(_ style: WaveGridStyle) -> some View {
        self
            .environment(\.waveGridColor, style.color)
            .environment(\.waveGridLineWidth, style.lineWidth)
            .environment(\.waveGridOpacity, style.opacity)
            .environment(\.waveGridLineCount, style.lineCount)
    }

    /// Sets the styling for the vertical drop lines.
    public func dropLineStyle(_ style: WaveDropLineStyle) -> some View {
        self
            .environment(\.waveDropLineColor, style.color)
            .environment(\.waveDropLineLineWidth, style.lineWidth)
            .environment(\.waveDropLineOpacity, style.opacity)
            .environment(\.waveDropLineCount, style.lineCount)
    }

    /// Sets the 3D camera angle and zoom.
    public func cameraAngle(_ config: WaveCameraConfig) -> some View {
        environment(\.waveCameraAngle, config)
    }

    /// Configures the continuous phase-shift animation.
    ///
    /// - Parameter speed: The animation speed multiplier. Pass `nil` to disable animation.
    public func animated(speed: Double?) -> some View {
        self
            .environment(\.waveAnimated, speed != nil)
            .environment(\.waveAnimationSpeed, speed ?? 1.0)
    }

    /// Configures a target wave for interference comparison.
    ///
    /// - Parameter target: The target wave configuration. Pass `nil` to remove interference.
    @ViewBuilder
    public func interference(with target: TargetWave?) -> some View {
        if let target = target {
            self
                .environment(\.waveTargetFunction, target.function)
                .environment(\.waveTargetAmplitude, target.amplitude)
                .environment(\.waveTargetFrequency, target.frequency)
                .environment(\.waveTargetPhase, target.phase)
                .environment(\.waveTargetColor, target.color)
        } else {
            self
                .environment(\.waveTargetFunction, nil)
        }
    }

    /// Forces the wave to render in 2D vector mode instead of the default 3D SceneKit mode.
    public func render2D() -> some View {
        environment(\.waveRenderMode, .twoDimensional)
    }

    // MARK: - Deprecated Granular API

    @available(*, deprecated, renamed: "waveform(amplitude:frequency:phase:)")
    public func amplitude(_ value: Double) -> some View {
        environment(\.waveAmplitude, value)
    }

    @available(*, deprecated, renamed: "waveform(amplitude:frequency:phase:)")
    public func frequency(_ value: Double) -> some View {
        environment(\.waveFrequency, value)
    }

    @available(*, deprecated, renamed: "waveform(amplitude:frequency:phase:)")
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

    @available(*, deprecated, renamed: "waveStyle(_:)")
    public func waveColor(_ color: Color) -> some View {
        environment(\.waveStrokeColor, color)
    }

    @available(*, deprecated, renamed: "waveStyle(_:)")
    public func waveLineWidth(_ width: CGFloat) -> some View {
        environment(\.waveLineWidth, width)
    }

    @available(*, deprecated, renamed: "waveStyle(_:)")
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

    @available(*, deprecated, renamed: "waveStyle(_:)")
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

    @available(*, deprecated, renamed: "animated(speed:)")
    public func animated(_ enabled: Bool = true) -> some View {
        environment(\.waveAnimated, enabled)
    }

    @available(*, deprecated, renamed: "animated(speed:)")
    public func animationSpeed(_ speed: Double) -> some View {
        environment(\.waveAnimationSpeed, speed)
    }

    /// Sets the progress length of the wave along the Z-axis (0.0 to 1.0).
    public func progress(_ value: Double) -> some View {
        environment(\.waveProgress, value)
    }

    @available(*, deprecated, renamed: "interference(with:)")
    public func showInterference(_ enabled: Bool) -> some View {
        // Obsolete modifier
        self
    }

    /// Animates the alignment (transitioning target and user wave overlap).
    public func isAligning(_ enabled: Bool) -> some View {
        environment(\.waveIsAligning, enabled)
    }

    @available(*, deprecated, renamed: "interference(with:)")
    public func targetAmplitude(_ value: Double) -> some View {
        environment(\.waveTargetAmplitude, value)
    }

    @available(*, deprecated, renamed: "interference(with:)")
    public func targetFrequency(_ value: Double) -> some View {
        environment(\.waveTargetFrequency, value)
    }

    @available(*, deprecated, renamed: "interference(with:)")
    public func targetPhase(_ value: Double) -> some View {
        environment(\.waveTargetPhase, value)
    }

    @available(*, deprecated, renamed: "interference(with:)")
    public func targetColor(_ color: Color) -> some View {
        environment(\.waveTargetColor, color)
    }

    @available(*, deprecated, renamed: "interference(with:)")
    public func targetFunction(_ function: WaveFunction) -> some View {
        environment(\.waveTargetFunction, function)
    }


}
