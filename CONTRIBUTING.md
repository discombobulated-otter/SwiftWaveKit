# Contributing to WaveKit

Thanks for considering a contribution. This doc covers how to set up the project, what we expect from PRs, and the design principles the API follows so new additions stay consistent with the rest of the library.

---

## Getting Started

### Requirements
- Xcode 15+ / Swift 5.9+
- macOS (SceneKit rendering is exercised via the `WaveKitExample` app, best tested on-device or in Simulator)

### Setup
```bash
git clone https://github.com/kartikkaushikk/SwiftWaveKit.git
cd SwiftWaveKit
swift build
swift test
```

To run the example app, open `Example/WaveKitExample.xcodeproj` (or the workspace, if present) in Xcode and run the `WaveKitExample` scheme. See the [Simulator Target Troubleshooting](README.md#simulator-target-troubleshooting) section of the README if you hit a bundle ID crash on Simulator.

---

## Project Structure

| File | Responsibility |
|---|---|
| `WaveFunction.swift` | Core math wrapper + operator overloads (`+`, `-`, `*`) |
| `WavePreset.swift` | Static built-in wave presets (sine, square, gaussian, etc.) |
| `FunctionShape.swift` | 2D `Shape` rendering path (`.render2D()` mode) |
| `WaveVisualizer3D.swift` | SceneKit ribbon rendering — grid, drop lines, camera, materials |
| `WaveConfiguration.swift` | Environment keys and public config structs (`WaveStyle`, `WaveGridStyle`, etc.) |
| `WaveModifiers.swift` | Public `View` modifier API |
| `WaveView.swift` | Entry point, routes between 2D/3D based on environment |

If you're not sure where a change belongs, open an issue first — happy to point you in the right direction before you write code.

---

## Design Principles (please read before adding a modifier)

WaveKit went through a deliberate API consolidation to avoid modifier sprawl. Before adding a new public modifier, ask:

1. **Is this the same visual decision as something that already exists?** If so, it likely belongs as a new field on an existing struct (`WaveStyle`, `WaveGridStyle`, `WaveDropLineStyle`, `WaveCameraConfig`), not a new standalone modifier. Example: wave opacity and glow intensity went into `WaveStyle` rather than becoming `.waveOpacity()` and `.waveGlow()`.
2. **Is this a genuinely distinct visual element?** If so, it deserves its own struct/modifier rather than being merged into an existing one just to save a modifier name. Example: grid lines and drop lines look similar but are functionally independent (a user may want one without the other), so they're deliberately separate — `WaveGridStyle` and `WaveDropLineStyle`.
3. **Avoid boolean + value pairs that can conflict.** Don't add a `showX: Bool` alongside an `xCount: Int` — collapse them so `count == 0` means hidden. This avoids invalid states like `showGrid: true` with `lineCount: 0`.
4. **Don't hardcode specific "looks" into the core API.** Flags like the old `.isECG()` bake one narrow visual outcome into the library permanently. If you want to showcase a specific effect, add it as a `WavePreset` (composable math) and/or an example demo, not a boolean modifier.
5. **Ship a preset with anything configurable.** If you add a new style struct, add at least one or two static presets (see `.neon`, `.minimal`, `.subtle`, `.dense`) so most users never have to hand-tune fields.

If a proposed change doesn't fit any of the above cleanly, raise it in an issue or draft PR description and we'll figure out the right shape together.

---

## Making Changes

1. **Fork the repo and branch from `main`.** Use a descriptive branch name, e.g. `fix/grid-line-count-zero`, `feat/wave-camera-config`.
2. **Keep PRs focused.** One feature or fix per PR — makes review and changelog entries easier.
3. **Update the README** if you touch the public API (`WaveModifiers.swift`, `WaveConfiguration.swift`). The [Complete API Reference](README.md#complete-api-reference) and [Migrating from Pre-1.0 Modifiers](README.md#migrating-from-pre-10-modifiers) tables should stay accurate.
4. **Update `CHANGELOG.md`** under an `Unreleased` heading, following [Keep a Changelog](https://keepachangelog.com/) format.
5. **Breaking changes need a migration note.** If you remove or rename a public modifier, add a row to the migration table in the README and call it out clearly in the PR description.
6. **Add/update tests** for any change to `WaveFunction` math, coordinate mapping in `FunctionShape`, or mesh generation logic in `WaveVisualizer3D`.
7. **Run `swift build` and `swift test`** before opening the PR — CI will also run these, but catching failures locally saves round-trips.

---

## Commit Messages

Keep them short and specific. Prefer:
```
Fix drop line count not resetting to 0 when hidden
```
over:
```
fixes
```

Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`) are welcome but not required.

---

## Opening a Pull Request

- Describe **what** changed and **why**, not just what files were touched.
- Link any related issue.
- Include a before/after screenshot or short screen recording for anything visual (styling, grid, camera, new demos) — this is a rendering library, visuals matter more than usual for review.
- Mark the PR as a draft if it's not ready for review yet; happy to give early feedback on direction before you polish.

---

## Reporting Bugs

Please include:
- WaveKit version / commit SHA
- Xcode + Swift version
- Minimal reproducing code snippet (a `WaveView` with the modifiers that trigger the issue)
- Expected vs. actual behavior
- Screenshot or recording if it's visual

## Suggesting Features

Open an issue describing the use case first, rather than jumping straight to a PR — especially for anything touching the public modifier API, given the design principles above. This avoids rework if the shape needs discussion.

---

## Code of Conduct

This project follows the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you're expected to uphold it.

---

## License

By contributing, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).
