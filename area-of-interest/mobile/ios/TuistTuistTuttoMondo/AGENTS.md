# Repository guide

This repository is a hands-on Tuist learning project. `TUTORIAL.md` is the curriculum and must be treated as the source of truth for the learning sequence.

## Coaching protocol

When the user asks to start or continue the tutorial:

1. Read `TUTORIAL.md`, inspect `git status`, and determine the last completed checkpoint from the files and command output. Do not assume that the whole tutorial has been completed.
2. Work on one numbered checkpoint at a time. Briefly explain the Tuist concept and why the step exists before giving instructions.
3. Let the user make the tutorial changes. Do not edit files or run a mutating command on their behalf unless they explicitly ask you to drive that step.
4. At each `STOP` marker, inspect the result, run the checkpoint's safe verification commands when appropriate, explain any failure, and wait for the user to continue.
5. Preserve unrelated and uncommitted work. In particular, preserve the current greeting in `TuistTuistTuttoMondo/ContentView.swift` and the repository's existing `.gitignore` rules unless the active checkpoint intentionally changes them.
6. Do not skip directly to the completed solution. Prefer a useful hint before revealing an exercise answer.

If the user asks for ordinary implementation work instead of a tutorial session, follow the final-state conventions below and verify the work normally.

## Project baseline

- Xcode: 26.3
- Minimum iOS version: 26.2
- App target: `TuistTuistTuttoMondo`
- Unit-test target: `TuistTuistTuttoMondoTests` using Swift Testing
- UI-test target: `TuistTuistTuttoMondoUITests` using XCTest
- App bundle ID: `com.fsferrara.TuistTuistTuttoMondo`
- Development team: `P2N837R7VM`
- There are no external package dependencies.

At the beginning of the tutorial, the checked-in `TuistTuistTuttoMondo.xcodeproj` is still the project definition. After the cutover checkpoint, `Project.swift` becomes the project definition and the generated Xcode project must not be tracked.

## Expected final architecture

The completed tutorial has these targets:

- `TuistTuistTuttoMondo` depends on `GreetingKit`.
- `TuistTuistTuttoMondoTests` depends on the app.
- `TuistTuistTuttoMondoUITests` depends on the app.
- `GreetingKit` exposes the greeting used by the app.
- `GreetingKitTests` depends on `GreetingKit`.

One shared `TuistTuistTuttoMondo` scheme builds the app and includes all three test targets. Keep target dependencies explicit in `Project.swift`.

## Tuist conventions

- Tuist is pinned by Mise. Run it through `mise exec --` so commands use the repository version.
- Edit `Project.swift` or `Tuist.swift`; never hand-edit generated `.xcodeproj` or `.xcworkspace` content.
- Keep generated root-level Xcode projects/workspaces and `Derived/` out of Git.
- Keep source and resource paths aligned with their target directories. Add a target dependency whenever code imports another local module.
- Use a minimal `Tuist.swift`; do not add `Tuist/Package.swift` until the project actually gains a package dependency.
- Preserve the existing bundle IDs, iOS deployment target, signing team, app icon, accent color, version, and concurrency settings unless the task explicitly changes them.

## Commands

From the repository root after the relevant tutorial checkpoint:

```bash
mise exec -- tuist version
mise exec -- tuist edit
mise exec -- tuist generate run --no-open
mise exec -- tuist test run TuistTuistTuttoMondo --no-selective-testing
mise exec -- tuist graph --format svg --output-path /tmp/TuistTuistTuttoMondo-graph.svg --no-open
```

Use `--no-selective-testing` for a full local verification. If the default simulator cannot be selected, list installed devices with `xcrun simctl list devices available` and pass `--device` and, when needed, `--os` to `tuist test run`.

Before handing off a code change, regenerate the project and run the smallest relevant test set. For build-system, target, dependency, or scheme changes, run the complete shared scheme. Documentation-only changes require `git diff --check` and a manual review of commands and paths.
