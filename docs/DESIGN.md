# WaveKit API Design Rationale

Full history and reasoning behind the WaveKit public API redesign, from the original 24-modifier surface down to the current consolidated version. For the terse, versioned list of what changed, see [CHANGELOG.md](../CHANGELOG.md). This document is the *why*.

Goal throughout: minimize modifiers a developer needs to touch while maximizing use cases covered, with `WaveView()` looking production-ready at zero config.

---

## Part 1 — Initial audit: 24 modifiers, too many decision points

Original surface, grouped as it existed:

- **General/2D (10):** `.amplitude()`, `.frequency()`, `.phase()`, `.xRange()`, `.sampleCount()`, `.waveColor()`, `.waveLineWidth()`, `.verticalOffset()`, `.gradient()`, `.gradientDirection()`
- **Animation (2):** `.animated()`, `.animationSpeed()`
- **3D render (5):** `.renderMode3D()`, `.progress()`, `.isECG()`, `.isPureTone()`, `.showGrid()`
- **Interference/target (7):** `.showInterference()`, `.targetFunction()`, `.targetAmplitude()`, `.targetFrequency()`, `.targetPhase()`, `.targetColor()`, `.isAligning()`

**Problem:** too many modifiers map to the same underlying visual decision, forcing multi-call chains for what's mentally one choice.

---

## 2. Collapsed math modifiers into a combinator

**Before:** `.amplitude()`, `.frequency()`, `.phase()` — 3 modifiers
**After:** `.waveform(amplitude:frequency:phase:)` — 1 combinator (originals kept as thin deprecated wrappers)

**Reason:** These are reasoned about together as "the shape of the wave," not independently — nobody sets frequency without thinking about amplitude too.

---

## 3. Collapsed style modifiers into `WaveStyle`

**Before:** `.waveColor()`, `.waveLineWidth()`, `.gradient()`, `.gradientDirection()` — 4 modifiers
**After:** `.waveStyle(_:)` taking a struct, with presets (`.neon`, `.minimal`)

```swift
struct WaveStyle {
    var color: Color = .primary
    var lineWidth: CGFloat = 2
    var gradient: WaveGradient? = nil
}
```

**Reason:** Color, width, gradient are one decision — "how does the line look." Presets mean most users never hand-configure style at all.

---

## 4. Collapsed animation modifiers

**Before:** `.animated()`, `.animationSpeed()` — 2 modifiers
**After:** `.animated(speed:)` — 1 modifier, `nil`/`false` disables

**Reason:** Speed is meaningless without animation on; functionally one toggle with an optional intensity, not two decisions.

---

## 5. Removed semantic 3D flags entirely (`isECG`, `isPureTone`)

**Before:** Hardcoded booleans baked specific visual "looks" into the core API.
**After:** Removed completely. Achieved instead via composing `WaveFunction` presets (`.sine + .gaussian`) + `.waveStyle(.neon)`.

**Reason:** These were style aliases pretending to be wave types — a leaky abstraction hardcoding one narrow use case (green glow = heartbeat) permanently into the API. The library already has the real primitive for this (composable `WaveFunction` math via operators). Pushing "recipes" into docs/examples instead of the API keeps the surface general-purpose, makes for better marketing content, and lets the library grow via new `WavePreset` entries without ever touching the modifier surface again.

---

## 6. Collapsed interference modifiers into one

**Before:** `.showInterference()`, `.targetFunction()`, `.targetAmplitude()`, `.targetFrequency()`, `.targetPhase()`, `.targetColor()`, `.isAligning()` — 7 modifiers
**After:** `.interference(with: TargetWave)` — 1 modifier; `target` being non-nil is itself the on/off switch

**Reason:** Worst offender in the original API — 7 modifiers for a feature never used partially. Making presence-of-target the toggle removes a redundant boolean and eliminates invalid states (e.g. `showInterference: true` with no target set).

---

## 7. Made 3D the default render mode (was 2D)

**Before:** `renderMode: .twoDimensional` default; 3D required explicit `.renderMode3D()`
**After:** `renderMode: .threeDimensional` default; 2D is the opt-out via `.render2D()`

**Reason:** 3D SceneKit rendering is WaveKit's actual differentiator — flat 2D paths are trivial in vanilla SwiftUI and don't need a library. Defaulting to 2D buried the interesting part behind an extra call. `WaveView()` alone should be screenshot-worthy.

**Flagged, unresolved:** SceneKit-by-default performance cost in lists/multi-instance layouts vs. cheap `Path` strokes; Xcode Preview/Simulator responsiveness; respecting `UIAccessibility.isReduceMotionEnabled` given animation + 3D both on by default; fallback behavior on platforms without SceneKit (e.g. watchOS).

---

## 8. Removed `.render3D()` wrapper entirely

**Before:** 3D config gated behind `.render3D(progress:showGrid:)`
**After:** Removed. `progress` and grid/drop-line params became top-level modifiers since 3D is always-on by default. `.render2D()` remains the single one-way mode switch; no `WaveRenderMode` enum is exposed publicly at all.

**Reason:** Once 3D is default rather than opt-in, wrapping its config behind a mode-specific "enable" call is dead ceremony — nothing left to "turn on."

---

## 9. Expanded `WaveStyle` with opacity and glow

**Before:** `WaveStyle` had only `color`, `lineWidth`, `gradient`.
**After:** Added `opacity: Double = 1.0` and `glowIntensity: Double = 0.0`.

**Reason:** Same category of decision as color/width — "how does the wave itself look." Belongs in the existing struct, not a new standalone modifier (the exact trap that produced the original 24).

---

## 10. Split grid and drop lines into two independent styles

**Initial plan (rejected):** One `WaveGridStyle` with a single `lineCount` controlling both the floor-plane grid and the vertical drop lines, drop lines inheriting grid color/opacity.

**Problem caught:** Grid (floor perspective plane) and drop lines (verticals connecting wave to base) are visually and functionally distinct. A user might want drop lines with no grid, or the reverse — a shared toggle/count makes that combination unreachable.

**Final approach:** Two separate structs, each independently off-able (`lineCount: 0` = hidden):

```swift
struct WaveGridStyle {
    var color: Color = .gray
    var lineWidth: CGFloat = 1
    var opacity: Double = 0.3
    var lineCount: Int = 12
}

struct WaveDropLineStyle {
    var color: Color = .gray
    var lineWidth: CGFloat = 1
    var opacity: Double = 0.3
    var lineCount: Int = 30
}
```

**Reason this isn't re-adding bloat:** the earlier consolidation collapsed *flat scalar modifiers describing the same element* (multiple calls for one visual thing). Grid and drop lines are two *different* elements — merging them to save a modifier name would trade away a real use case to save a symbol, the wrong axis to optimize. Both ship presets (`.subtle`, `.dense`) so a single call still covers most usage.

---

## 11. Removed `.showGrid(Bool)` entirely

**Before:** `.showGrid(_:)` backed by `WaveShowGridKey`, boolean on/off.
**After:** Removed. Replaced by `WaveGridStyle.lineCount == 0` and `WaveDropLineStyle.lineCount == 0`.

**Reason:** A separate boolean next to a count creates a conflicting state (`showGrid: true` + `lineCount: 0`). Making count the source of truth removes the invalid combination — same fix as `showInterference` + `targetFunction` earlier.

**Breaking change:** existing `.showGrid(true)` call sites migrate to `.gridStyle(.dense)` or similar; `WaveShowGridKey` deleted.

---

## 12. Added camera configuration

**Before:** No camera control; angle/distance presumably fixed in `WaveVisualizer3D.swift`.
**After:** New `WaveCameraConfig` struct + one modifier.

```swift
struct WaveCameraConfig {
    var azimuth: Double = 0.0
    var elevation: Double = 15.0
    var distance: Double = 10.0
}

extension WaveCameraConfig {
    static let front = WaveCameraConfig(azimuth: 0, elevation: 0)
    static let iso = WaveCameraConfig(azimuth: 45, elevation: 25)
}
```

**Reason:** Camera direction is orthogonal to styling — "where am I looking from," not "how does something look" — so it gets its own struct rather than folding into `WaveStyle`/`WaveGridStyle`. Default likely wants to be `.iso` rather than a flat front view, since a dead-on angle undercuts the depth that motivated 3D-by-default in the first place.

---

## Net result

**Before:** 24 modifiers across general/2D, animation, 3D, and interference groups.
**After:** ~9 modifier families:

`.waveform()` · `.waveStyle()` · `.animated(speed:)` · `.progress()` · `.gridStyle()` · `.dropLineStyle()` · `.cameraAngle()` · `.render2D()` · `.interference(with:)`

```swift
// Zero-config: 3D, animated, styled reasonably, camera at a sensible angle
WaveView(function: .sine)

// Typical real usage
WaveView(function: .sine + .gaussian)
    .waveStyle(.neon)
    .gridStyle(.subtle)
    .cameraAngle(.iso)
    .interference(with: .square)
```

## Backward compatibility

Original fine-grained modifiers (`.amplitude()`, `.waveColor()`, etc.) remain as thin wrappers writing into the same environment keys the grouped modifiers use, marked `@available(*, deprecated, renamed:)`. Avoids a breaking v2 rewrite while steering new users/docs toward the consolidated API. `.showGrid()` is the one hard removal (no non-breaking equivalent since the boolean/count conflict couldn't be preserved safely).

## Design Principles for Future Contributions

These are the rules that emerged from the process above — see [CONTRIBUTING.md](../CONTRIBUTING.md) for the contributor-facing version:

1. Same visual decision → same struct, not a new standalone modifier.
2. Genuinely distinct visual element → its own struct, don't merge for the sake of fewer modifier names.
3. No `showX: Bool` next to an `xCount: Int` — collapse so `count == 0` means hidden.
4. Don't hardcode specific "looks" as flags — compose via `WaveFunction` and ship as a preset/example instead.
5. Any new configurable struct ships with at least one preset.
