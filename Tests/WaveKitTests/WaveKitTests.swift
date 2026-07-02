import Testing
import Foundation
@testable import WaveKit

// MARK: - WaveFunction Preset Tests

@Test func sinePresetEvaluatesCorrectly() {
    let sine = WaveFunction.sine
    #expect(abs(sine.evaluate(0)) < 1e-10)
    #expect(abs(sine.evaluate(.pi / 2) - 1.0) < 1e-10)
    #expect(abs(sine.evaluate(.pi)) < 1e-10)
    #expect(abs(sine.evaluate(3 * .pi / 2) + 1.0) < 1e-10)
}

@Test func cosinePresetEvaluatesCorrectly() {
    let cosine = WaveFunction.cosine
    #expect(abs(cosine.evaluate(0) - 1.0) < 1e-10)
    #expect(abs(cosine.evaluate(.pi / 2)) < 1e-10)
    #expect(abs(cosine.evaluate(.pi) + 1.0) < 1e-10)
}

@Test func triangleWaveOscillatesBetweenNeg1And1() {
    let triangle = WaveFunction.triangle
    #expect(abs(triangle.evaluate(.pi / 2) - 1.0) < 1e-10)
    #expect(abs(triangle.evaluate(-.pi / 2) + 1.0) < 1e-10)
}

@Test func squareWaveAlternatesBetweenValues() {
    let square = WaveFunction.square
    #expect(square.evaluate(0.1) == 1.0)
    #expect(square.evaluate(.pi + 0.1) == -1.0)
}

@Test func sawtoothWaveIsLinear() {
    let sawtooth = WaveFunction.sawtooth
    #expect(abs(sawtooth.evaluate(0)) < 1e-10)
}

@Test func dampedWaveDecays() {
    let damped = WaveFunction.damped
    #expect(abs(damped.evaluate(0)) < 1e-10)
    let earlyPeak = abs(damped.evaluate(.pi / 10))
    let latePeak = abs(damped.evaluate(2 * .pi + .pi / 10))
    #expect(earlyPeak > latePeak)
}

@Test func gaussianPeaksAtZero() {
    let gaussian = WaveFunction.gaussian
    #expect(abs(gaussian.evaluate(0) - 1.0) < 1e-10)
    #expect(abs(gaussian.evaluate(1.0) - gaussian.evaluate(-1.0)) < 1e-10)
    #expect(gaussian.evaluate(0) > gaussian.evaluate(1.0))
    #expect(gaussian.evaluate(1.0) > gaussian.evaluate(3.0))
}

// MARK: - Function Composition Tests

@Test func functionAddition() {
    let combined = WaveFunction.sine + WaveFunction.cosine
    let x = 1.0
    let expected = sin(x) + cos(x)
    #expect(abs(combined.evaluate(x) - expected) < 1e-10)
}

@Test func functionMultiplication() {
    let product = WaveFunction.sine * WaveFunction.cosine
    let x = 1.0
    let expected = sin(x) * cos(x)
    #expect(abs(product.evaluate(x) - expected) < 1e-10)
}

@Test func scalarMultiplication() {
    let scaled = 2.0 * WaveFunction.sine
    #expect(abs(scaled.evaluate(.pi / 2) - 2.0) < 1e-10)
}

@Test func functionSubtraction() {
    let diff = WaveFunction.sine - WaveFunction.cosine
    let x = 1.0
    let expected = sin(x) - cos(x)
    #expect(abs(diff.evaluate(x) - expected) < 1e-10)
}

// MARK: - Parameterized Preset Tests

@Test func sineWithCustomFrequency() {
    let wave = WaveFunction.sine(frequency: 3.0)
    let x: Double = .pi / 6
    #expect(abs(wave.evaluate(x) - 1.0) < 1e-10)
}

@Test func dampedWithCustomParameters() {
    let wave = WaveFunction.damped(decay: 0.5, frequency: 2.0)
    let x = 1.0
    let expected = exp(-0.5 * x) * sin(2.0 * x)
    #expect(abs(wave.evaluate(x) - expected) < 1e-10)
}

@Test func gaussianWithCustomSigma() {
    let wave = WaveFunction.gaussian(sigma: 2.0)
    #expect(abs(wave.evaluate(0) - 1.0) < 1e-10)
    let narrow = WaveFunction.gaussian(sigma: 0.5)
    #expect(wave.evaluate(1.0) > narrow.evaluate(1.0))
}

// MARK: - Custom Closure Tests

@Test func customClosureFunction() {
    let wave = WaveFunction { x in x * x }
    #expect(abs(wave.evaluate(3.0) - 9.0) < 1e-10)
    #expect(abs(wave.evaluate(-2.0) - 4.0) < 1e-10)
}
