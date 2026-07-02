//
//  WavePreset.swift
//  WaveKit
//
//  Built-in wave function presets for common mathematical waveforms.
//

import Foundation

extension WaveFunction {

    // MARK: - Standard Waveforms

    /// A sine wave: `sin(x)`
    public static let sine = WaveFunction { sin($0) }

    /// A cosine wave: `cos(x)`
    public static let cosine = WaveFunction { cos($0) }

    /// A triangle wave: `(2/π) * asin(sin(x))`
    ///
    /// Produces a linear zigzag pattern oscillating between -1 and 1.
    public static let triangle = WaveFunction { x in
        (2.0 / .pi) * asin(sin(x))
    }

    /// A square wave: `sign(sin(x))`
    ///
    /// Produces a waveform that alternates between -1 and 1 with sharp transitions.
    public static let square = WaveFunction { x in
        let s = sin(x)
        if s > 0 { return 1.0 }
        if s < 0 { return -1.0 }
        return 0.0
    }

    /// A sawtooth wave: `2 * (x/2π − floor(x/2π + 0.5))`
    ///
    /// A linearly rising ramp that resets sharply, oscillating between -1 and 1.
    public static let sawtooth = WaveFunction { x in
        let normalized = x / (2.0 * .pi)
        return 2.0 * (normalized - floor(normalized + 0.5))
    }

    /// A damped sine wave: `exp(−0.2x) * sin(5x)`
    ///
    /// A sine wave whose amplitude decays exponentially — useful for
    /// visualizing oscillations losing energy over time.
    public static let damped = WaveFunction { x in
        exp(-0.2 * x) * sin(5.0 * x)
    }

    /// A Gaussian bell curve: `exp(−x²/2)`
    ///
    /// A smooth, symmetric bump centered at x = 0.
    public static let gaussian = WaveFunction { x in
        exp(-(x * x) / 2.0)
    }

    // MARK: - Parameterized Constructors

    /// Creates a sine wave with a custom frequency.
    ///
    /// - Parameter frequency: The number of cycles per 2π interval.
    /// - Returns: A new `WaveFunction`.
    public static func sine(frequency: Double) -> WaveFunction {
        WaveFunction { x in sin(frequency * x) }
    }

    /// Creates a cosine wave with a custom frequency.
    ///
    /// - Parameter frequency: The number of cycles per 2π interval.
    /// - Returns: A new `WaveFunction`.
    public static func cosine(frequency: Double) -> WaveFunction {
        WaveFunction { x in cos(frequency * x) }
    }

    /// Creates a damped wave with custom decay rate and oscillation frequency.
    ///
    /// - Parameters:
    ///   - decay: The exponential decay rate. Higher values = faster decay.
    ///   - frequency: The oscillation frequency.
    /// - Returns: A new `WaveFunction`.
    public static func damped(decay: Double = 0.2, frequency: Double = 5.0) -> WaveFunction {
        WaveFunction { x in exp(-decay * x) * sin(frequency * x) }
    }

    /// Creates a Gaussian bell curve with a custom standard deviation.
    ///
    /// - Parameter sigma: The standard deviation controlling the width. Default is 1.0.
    /// - Returns: A new `WaveFunction`.
    public static func gaussian(sigma: Double = 1.0) -> WaveFunction {
        let twoSigmaSquared = 2.0 * sigma * sigma
        return WaveFunction { x in exp(-(x * x) / twoSigmaSquared) }
    }
}
