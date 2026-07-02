//
//  WaveConfiguration.swift
//  WaveKit
//
//  A value type holding all customization parameters for a WaveView.
//  This is used internally by the environment-based modifier system.
//

import SwiftUI

/// The direction of a gradient applied to a wave.
public enum WaveGradientDirection: Sendable {
    /// Gradient runs horizontally (left to right).
    case horizontal
    /// Gradient runs vertically (top to bottom).
    case vertical
}

/// The type of gradient applied to a wave.
public enum WaveGradientStyle: Sendable {
    /// A linear gradient in the specified direction.
    case linear
    /// A radial gradient emanating from the center.
    case radial
    /// An angular (conic) gradient sweeping around the center.
    case angular
}

/// Holds the gradient configuration for a wave.
public struct WaveGradient: Sendable, Equatable {
    /// The SwiftUI gradient (color stops).
    public var gradient: Gradient
    /// The gradient rendering style.
    public var style: WaveGradientStyle
    /// The gradient direction (used for linear style).
    public var direction: WaveGradientDirection

    public init(
        gradient: Gradient,
        style: WaveGradientStyle = .linear,
        direction: WaveGradientDirection = .vertical
    ) {
        self.gradient = gradient
        self.style = style
        self.direction = direction
    }

    public static func == (lhs: WaveGradient, rhs: WaveGradient) -> Bool {
        // Gradient doesn't conform to Equatable by default, compare by identity
        lhs.style == rhs.style && lhs.direction == rhs.direction
    }
}

/// Holds all configuration parameters for rendering a wave.
///
/// This type is used internally by the environment-based modifier system.
/// You typically don't create this directly — instead, use the view modifiers
/// on `WaveView`.
public struct WaveConfiguration: Sendable {
    public var amplitude: Double = 1.0
    public var frequency: Double = 1.0
    public var phase: Double = 0.0
    public var xRange: ClosedRange<Double> = 0...(2 * .pi)
    public var sampleCount: Int = 200
    public var lineWidth: CGFloat = 2.0
    public var strokeColor: Color = .primary
    public var waveGradient: WaveGradient?
    public var verticalOffset: Double = 0.0
    public var isAnimated: Bool = true
    public var animationSpeed: Double = 1.0
    
    // 3D Visualizer settings
    public var renderMode: WaveRenderMode = .twoDimensional
    public var progress: Double = 1.0
    public var showInterference: Bool = false
    public var isAligning: Bool = false
    public var targetAmplitude: Double = 1.0
    public var targetFrequency: Double = 1.0
    public var targetPhase: Double = 0.0
    public var targetColor: Color = .white
    public var targetFunction: WaveFunction? = nil
    public var isPureTone: Bool = false

    public init() {}
}

// MARK: - SwiftUI Environment Keys

struct WaveAmplitudeKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveFrequencyKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WavePhaseKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

struct WaveXRangeKey: EnvironmentKey {
    static let defaultValue: ClosedRange<Double> = 0...(2 * .pi)
}

struct WaveSampleCountKey: EnvironmentKey {
    static let defaultValue: Int = 200
}

struct WaveLineWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = 2.0
}

struct WaveStrokeColorKey: EnvironmentKey {
    static let defaultValue: Color = .primary
}

struct WaveGradientKey: EnvironmentKey {
    static let defaultValue: WaveGradient? = nil
}

struct WaveVerticalOffsetKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

struct WaveAnimatedKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

struct WaveAnimationSpeedKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

extension EnvironmentValues {
    var waveAmplitude: Double {
        get { self[WaveAmplitudeKey.self] }
        set { self[WaveAmplitudeKey.self] = newValue }
    }

    var waveFrequency: Double {
        get { self[WaveFrequencyKey.self] }
        set { self[WaveFrequencyKey.self] = newValue }
    }

    var wavePhase: Double {
        get { self[WavePhaseKey.self] }
        set { self[WavePhaseKey.self] = newValue }
    }

    var waveXRange: ClosedRange<Double> {
        get { self[WaveXRangeKey.self] }
        set { self[WaveXRangeKey.self] = newValue }
    }

    var waveSampleCount: Int {
        get { self[WaveSampleCountKey.self] }
        set { self[WaveSampleCountKey.self] = newValue }
    }

    var waveLineWidth: CGFloat {
        get { self[WaveLineWidthKey.self] }
        set { self[WaveLineWidthKey.self] = newValue }
    }

    var waveStrokeColor: Color {
        get { self[WaveStrokeColorKey.self] }
        set { self[WaveStrokeColorKey.self] = newValue }
    }

    var waveGradient: WaveGradient? {
        get { self[WaveGradientKey.self] }
        set { self[WaveGradientKey.self] = newValue }
    }

    var waveVerticalOffset: Double {
        get { self[WaveVerticalOffsetKey.self] }
        set { self[WaveVerticalOffsetKey.self] = newValue }
    }

    var waveAnimated: Bool {
        get { self[WaveAnimatedKey.self] }
        set { self[WaveAnimatedKey.self] = newValue }
    }

    var waveAnimationSpeed: Double {
        get { self[WaveAnimationSpeedKey.self] }
        set { self[WaveAnimationSpeedKey.self] = newValue }
    }
}

// MARK: - 3D Renderer Extensions

public enum WaveRenderMode: Sendable {
    case twoDimensional
    case threeDimensional
}

struct WaveRenderModeKey: EnvironmentKey {
    static let defaultValue: WaveRenderMode = .twoDimensional
}

struct WaveProgressKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveShowInterferenceKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct WaveIsAligningKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct WaveTargetAmplitudeKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveTargetFrequencyKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveTargetPhaseKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

struct WaveTargetColorKey: EnvironmentKey {
    static let defaultValue: Color = .white
}

struct WaveTargetFunctionKey: EnvironmentKey {
    static let defaultValue: WaveFunction? = nil
}

struct WaveIsECGKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct WaveIsPureToneKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    public var waveRenderMode: WaveRenderMode {
        get { self[WaveRenderModeKey.self] }
        set { self[WaveRenderModeKey.self] = newValue }
    }
    public var waveProgress: Double {
        get { self[WaveProgressKey.self] }
        set { self[WaveProgressKey.self] = newValue }
    }
    public var waveShowInterference: Bool {
        get { self[WaveShowInterferenceKey.self] }
        set { self[WaveShowInterferenceKey.self] = newValue }
    }
    public var waveIsAligning: Bool {
        get { self[WaveIsAligningKey.self] }
        set { self[WaveIsAligningKey.self] = newValue }
    }
    public var waveTargetAmplitude: Double {
        get { self[WaveTargetAmplitudeKey.self] }
        set { self[WaveTargetAmplitudeKey.self] = newValue }
    }
    public var waveTargetFrequency: Double {
        get { self[WaveTargetFrequencyKey.self] }
        set { self[WaveTargetFrequencyKey.self] = newValue }
    }
    public var waveTargetPhase: Double {
        get { self[WaveTargetPhaseKey.self] }
        set { self[WaveTargetPhaseKey.self] = newValue }
    }
    public var waveTargetColor: Color {
        get { self[WaveTargetColorKey.self] }
        set { self[WaveTargetColorKey.self] = newValue }
    }
    public var waveTargetFunction: WaveFunction? {
        get { self[WaveTargetFunctionKey.self] }
        set { self[WaveTargetFunctionKey.self] = newValue }
    }
    public var waveIsPureTone: Bool {
        get { self[WaveIsPureToneKey.self] }
        set { self[WaveIsPureToneKey.self] = newValue }
    }
    public var waveIsECG: Bool {
        get { self[WaveIsECGKey.self] }
        set { self[WaveIsECGKey.self] = newValue }
    }
}
