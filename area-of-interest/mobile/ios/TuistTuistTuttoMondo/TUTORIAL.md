# Learn Tuist by migrating TuistTuistTuttoMondo

This is a workbook, not a finished Tuist setup. You will turn the existing Xcode-created SwiftUI application into a Tuist-generated project, validate the migration, and then add a small framework to experience Tuist's dependency graph.

Work through one checkpoint at a time. When you reach a **STOP**, ask your coding agent to inspect what you did and help with any error before continuing.

The examples target Xcode 26.3, iOS 26.2, and Tuist 4.208.0. They use the current command form such as `tuist generate run` and `tuist test run`.

## What you will learn

By the end, you will be able to:

- explain the difference between a Tuist manifest and a generated Xcode project;
- model application, unit-test, and UI-test targets in `Project.swift`;
- edit, generate, run, and test a Tuist project;
- make `Project.swift` the single source of truth;
- add a local framework and understand its dependency edges; and
- diagnose the most common generation and simulator failures.

## The mental model

An Xcode-created project stores target membership, settings, dependencies, and schemes inside `project.pbxproj`. Tuist moves that intent into Swift manifests:

```text
Tuist.swift + Project.swift + source files
                    |
                    | tuist generate run
                    v
       generated workspace/project
                    |
                    v
             Xcode build system
```

Commit the manifests and source files. Regenerate the workspace when the graph changes. Do not make lasting changes inside the generated project, because the next generation replaces them.

Tuist can also provide remote caching, selective tests, previews, and build insights. Those features are deliberately outside this first tutorial: a small local project is the clearest place to learn project generation.

## Checkpoint 1: understand and protect the baseline

From the repository root, inspect the current state:

```bash
git status --short
git diff -- TuistTuistTuttoMondo/ContentView.swift
xcodebuild -version
xcodebuild -list -project TuistTuistTuttoMondo.xcodeproj
```

You should see Xcode 26.3 and these three targets:

- `TuistTuistTuttoMondo`
- `TuistTuistTuttoMondoTests`
- `TuistTuistTuttoMondoUITests`

Open the original project, choose any installed iOS simulator, run the app, and run the shared scheme's tests:

```bash
xed TuistTuistTuttoMondo.xcodeproj
```

The app should display “Tuist Tuist... tutto il mondo!”. Keep note of any pre-existing failing test; migration should not be confused with repairing unrelated behavior.

Why start here? A migration needs an observable baseline. If the generated project later behaves differently, you need to know whether Tuist introduced the difference.

> **STOP 1:** Ask the agent to confirm the target inventory and review the working tree before continuing.

## Checkpoint 2: pin Tuist with Mise

Tuist recommends Mise when a project needs the same tool version on every machine. Pin the version used to write this tutorial:

```bash
mise use tuist@4.208.0
mise exec -- tuist version
```

The second command should print `4.208.0`. `mise use` creates or updates `mise.toml` and may create a lock file. These are project inputs and should be committed when you eventually commit the migration.

Why use `mise exec -- tuist` instead of relying on `tuist` in `PATH`? It makes every command explicitly use the version pinned by this repository, even when your interactive shell has not activated Mise.

If installation fails, first run `mise doctor`. On a managed or proxied network, consult Tuist's HTTP proxy guidance rather than switching to an unpinned global installation.

> **STOP 2:** Show the agent `mise exec -- tuist version` and `git status --short`.

## Checkpoint 3: establish the Tuist root

### Ignore generated artifacts

The repository's `.gitignore` already ignores root-level `.xcodeproj` files. Ensure it also contains these entries exactly once:

```gitignore
/*.xcodeproj
/*.xcworkspace
/Derived
```

The first rule does not untrack the existing project; Git continues tracking files that were already committed. You will intentionally remove that project only after the generated replacement passes its checks.

### Create `Tuist.swift`

Create `Tuist.swift` at the repository root:

```swift
import ProjectDescription

let tuist = Tuist(project: .tuist())
```

This small file marks the project root and holds project-scoped Tuist behavior. It is intentionally boring. There is no `Tuist/Package.swift` because this application has no external dependencies.

Validate that Tuist can find the root:

```bash
mise exec -- tuist edit
```

Tuist should open a temporary manifest-editing project in Xcode. This is where you get completion and type checking for `ProjectDescription`; it is different from the application workspace you will generate.

Close the temporary project when you are done inspecting it.

> **STOP 3:** Ask the agent to inspect `Tuist.swift` and explain the difference between `tuist edit` and `tuist generate run`.

## Checkpoint 4: describe the existing project

Create `Project.swift` at the repository root with the following manifest. During migration the project name has a `-Tuist` suffix so it cannot overwrite the checked-in project that you are using for comparison. The target and scheme names remain unchanged.

```swift
import ProjectDescription

let project = Project(
    name: "TuistTuistTuttoMondo-Tuist",
    organizationName: "fsferrara",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    settings: .settings(
        base: [
            "IPHONEOS_DEPLOYMENT_TARGET": "26.2",
            "SWIFT_VERSION": "5.0",
        ]
    ),
    targets: [
        .target(
            name: "TuistTuistTuttoMondo",
            destinations: .iOS,
            product: .app,
            bundleId: "com.fsferrara.TuistTuistTuttoMondo",
            deploymentTargets: .iOS("26.2"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [:],
                    ],
                    "UIApplicationSupportsIndirectInputEvents": true,
                    "UILaunchScreen": [:],
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight",
                    ],
                    "UISupportedInterfaceOrientations~ipad": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationPortraitUpsideDown",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight",
                    ],
                ]
            ),
            sources: ["TuistTuistTuttoMondo/**/*.swift"],
            resources: ["TuistTuistTuttoMondo/Assets.xcassets"],
            dependencies: [],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "CODE_SIGN_STYLE": "Automatic",
                    "CURRENT_PROJECT_VERSION": "1",
                    "DEVELOPMENT_TEAM": "P2N837R7VM",
                    "ENABLE_PREVIEWS": "YES",
                    "MARKETING_VERSION": "1.0",
                    "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
                    "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                    "SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY": "YES",
                ]
            )
        ),
        .target(
            name: "TuistTuistTuttoMondoTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.fsferrara.TuistTuistTuttoMondoTests",
            deploymentTargets: .iOS("26.2"),
            infoPlist: .default,
            sources: ["TuistTuistTuttoMondoTests/**/*.swift"],
            dependencies: [
                .target(name: "TuistTuistTuttoMondo"),
            ]
        ),
        .target(
            name: "TuistTuistTuttoMondoUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "com.fsferrara.TuistTuistTuttoMondoUITests",
            deploymentTargets: .iOS("26.2"),
            infoPlist: .default,
            sources: ["TuistTuistTuttoMondoUITests/**/*.swift"],
            dependencies: [
                .target(name: "TuistTuistTuttoMondo"),
            ]
        ),
    ],
    schemes: [
        .scheme(
            name: "TuistTuistTuttoMondo",
            shared: true,
            buildAction: .buildAction(
                targets: ["TuistTuistTuttoMondo"]
            ),
            testAction: .targets(
                [
                    "TuistTuistTuttoMondoTests",
                    "TuistTuistTuttoMondoUITests",
                ]
            ),
            runAction: .runAction(
                configuration: .debug,
                executable: "TuistTuistTuttoMondo"
            )
        ),
    ]
)
```

Read the manifest before generating anything:

- `Project` replaces the structural information previously stored in `project.pbxproj`.
- A target's `product` tells Xcode what to build.
- `sources` and `resources` replace manual target membership.
- Both test targets explicitly depend on the application they exercise.
- Disabling automatic schemes ensures the explicit shared scheme is the one workflow everyone sees.
- The synthesized Info.plist starts from Tuist defaults and adds the launch, scene, input, and orientation behavior from the original project.
- The target settings preserve signing, versioning, asset catalogs, previews, and the Swift concurrency defaults created by Xcode 26.

Re-open the editing project and build its `Manifests` scheme. This catches Swift or ProjectDescription API mistakes before application generation:

```bash
mise exec -- tuist edit
```

> **STOP 4:** Ask the agent to review the manifest target-by-target. Do not continue while the `Manifests` scheme has a compiler error.

## Checkpoint 5: generate and validate side by side

Generate without automatically opening Xcode:

```bash
mise exec -- tuist generate run --no-open
```

You should now have an ignored generated project/workspace whose name contains `TuistTuistTuttoMondo-Tuist`. The original `TuistTuistTuttoMondo.xcodeproj` is still tracked and untouched.

Open the generated workspace reported by Tuist. Inspect it in Xcode and confirm:

- the shared `TuistTuistTuttoMondo` scheme exists;
- the application contains the two Swift source files and the asset catalog;
- the unit-test and UI-test targets contain their expected files;
- both test targets show a dependency on the app; and
- the app launches with the same greeting as the baseline.

Now exercise the CLI workflow:

```bash
mise exec -- tuist test run TuistTuistTuttoMondo --no-selective-testing
```

`tuist test run` generates what it needs, builds the test products, and runs the scheme. The `--no-selective-testing` flag makes this checkpoint run the complete suite rather than allowing prior run data to filter tests.

If Tuist cannot choose a simulator, discover what is installed:

```bash
xcrun simctl list devices available
```

Then retry with values from that output:

```bash
mise exec -- tuist test run TuistTuistTuttoMondo \
  --device "<installed device name>" \
  --os "<installed OS version>" \
  --no-selective-testing
```

Do not proceed merely because generation succeeded. Generation validates the graph; launching and testing validate its behavior.

> **STOP 5:** Show the agent the generation and test results. Ask it to compare the generated target graph with the original project.

## Checkpoint 6: make the manifest the source of truth

Only perform this checkpoint after Checkpoint 5 passes. Commit or stash any unrelated work before removing the old project.

First change the project name at the top of `Project.swift`:

```swift
name: "TuistTuistTuttoMondo",
```

Then remove the checked-in Xcode project and regenerate it from the manifest:

```bash
git rm -r TuistTuistTuttoMondo.xcodeproj
mise exec -- tuist generate run --no-open
git status --short
```

The Git status should show deletion of the old project files, while the newly generated project at the same path stays ignored. This is intentional: Git now records `Project.swift`, not generated `project.pbxproj`, as the build-graph definition.

Run the complete test checkpoint again:

```bash
mise exec -- tuist test run TuistTuistTuttoMondo --no-selective-testing
```

Recovery is straightforward before committing: `git restore --staged TuistTuistTuttoMondo.xcodeproj` followed by `git restore TuistTuistTuttoMondo.xcodeproj` restores the old tracked project. Do not restore it after you have accepted the cutover merely to make the deletion disappear from `git status`.

Any stale generated `-Tuist` project/workspace is disposable. Move those exact ignored items to Trash after closing them in Xcode; never delete source or manifest files as part of cleanup.

> **STOP 6:** Ask the agent to verify that `Project.swift` is tracked or ready to track, generated projects are ignored, and the old project deletion is intentional and recoverable.

## Checkpoint 7: add a real local module

Project generation becomes most valuable when the dependency graph grows. You will extract the greeting value into a framework without moving the SwiftUI view itself.

Create these directories:

```bash
mkdir -p Modules/GreetingKit/Sources
mkdir -p Modules/GreetingKit/Tests
```

Create `Modules/GreetingKit/Sources/Greeting.swift`:

```swift
public enum Greeting {
    public static let message = "Tuist Tuist... tutto il mondo!"
}
```

Create `Modules/GreetingKit/Tests/GreetingTests.swift`:

```swift
import Testing
@testable import GreetingKit

struct GreetingTests {
    @Test
    func messageGreetsTheWorld() {
        #expect(Greeting.message == "Tuist Tuist... tutto il mondo!")
    }
}
```

In `TuistTuistTuttoMondo/ContentView.swift`, add the module import:

```swift
import GreetingKit
import SwiftUI
```

Then replace the string literal with the framework API:

```swift
Text(Greeting.message)
```

### Extend the graph

In `Project.swift`, add these targets before the application target:

```swift
.target(
    name: "GreetingKit",
    destinations: .iOS,
    product: .framework,
    bundleId: "com.fsferrara.GreetingKit",
    deploymentTargets: .iOS("26.2"),
    infoPlist: .default,
    sources: ["Modules/GreetingKit/Sources/**/*.swift"],
    dependencies: []
),
.target(
    name: "GreetingKitTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.fsferrara.GreetingKitTests",
    deploymentTargets: .iOS("26.2"),
    infoPlist: .default,
    sources: ["Modules/GreetingKit/Tests/**/*.swift"],
    dependencies: [
        .target(name: "GreetingKit"),
    ]
),
```

Change the application target's empty dependencies to:

```swift
dependencies: [
    .target(name: "GreetingKit"),
],
```

Finally, add `GreetingKitTests` to the scheme's `testAction`:

```swift
testAction: .targets(
    [
        "TuistTuistTuttoMondoTests",
        "TuistTuistTuttoMondoUITests",
        "GreetingKitTests",
    ]
),
```

Why must `Greeting.message` be public? A framework is a separate Swift module. The application may only use declarations that the framework exports. The tests use `@testable` to access internal declarations too, but making the application rely on that would be impossible and undesirable.

Generate and test the expanded graph:

```bash
mise exec -- tuist generate run --no-open
mise exec -- tuist test run TuistTuistTuttoMondo --no-selective-testing
```

You should now have five targets and three passing test targets. The UI should be unchanged even though the source of its text moved across a module boundary.

> **STOP 7:** Ask the agent to verify the public API, all explicit dependencies, the shared scheme, and the complete test result.

## Checkpoint 8: inspect and focus the graph

Generate an SVG representation outside the repository:

```bash
mise exec -- tuist graph \
  --format svg \
  --output-path /tmp/TuistTuistTuttoMondo-graph.svg \
  --no-open
```

The important production edge is:

```text
TuistTuistTuttoMondo -> GreetingKit
```

The test edges should point from each test bundle to the target it tests. An arrow is not decoration: Tuist uses these declarations to order builds, link products, validate imports, focus generated projects, and determine what can be cached.

Try focused generation:

```bash
mise exec -- tuist generate run GreetingKit --no-open
```

Focused generation is useful in large workspaces. Tuist generates the selected target and the dependencies needed to work on it, while eligible unrelated targets can be omitted or represented by cached binaries. This small project will not become faster in a meaningful way, but the graph behavior is visible.

Regenerate the complete project when finished:

```bash
mise exec -- tuist generate run --no-open
```

> **STOP 8:** Explain the graph to the agent in your own words. The tutorial is complete when it confirms the edges and a final full test run passes.

## Daily workflow after the tutorial

Use these commands from the repository root:

```bash
# Edit and type-check manifests in Xcode
mise exec -- tuist edit

# Generate the complete application workspace
mise exec -- tuist generate run --no-open

# Generate and open it
mise exec -- tuist generate run

# Run every test in the shared scheme
mise exec -- tuist test run TuistTuistTuttoMondo --no-selective-testing

# Focus on one target
mise exec -- tuist generate run GreetingKit --no-open

# Visualize the graph without writing into the repository
mise exec -- tuist graph --format svg \
  --output-path /tmp/TuistTuistTuttoMondo-graph.svg --no-open
```

When adding a source file under an existing source glob, regenerate only if Xcode does not pick it up automatically. When adding a target, changing membership, or changing dependencies or schemes, edit `Project.swift` and regenerate.

## Troubleshooting by symptom

### `tuist: command not found`

Run through Mise:

```bash
mise install
mise exec -- tuist version
```

### `The file Project.swift could not be found`

Run the command from this repository or one of its subdirectories and confirm that root-level `Tuist.swift` and `Project.swift` exist.

### Manifest compiler error

Run `mise exec -- tuist edit`, select the `Manifests` scheme, and build it. Fix the first Swift compiler error before considering later diagnostics.

### `No files found at path ...`

Compare the manifest glob with the real spelling and capitalization on disk:

```bash
find TuistTuistTuttoMondo TuistTuistTuttoMondoTests \
  TuistTuistTuttoMondoUITests Modules -type f | sort
```

### `No such module GreetingKit`

Check both sides of the graph: `GreetingKit` must be a target, and the app target must declare `.target(name: "GreetingKit")` in its dependencies. Then regenerate.

### Signing failure

Simulator builds generally do not need a provisioning profile. Confirm that the manifest retained automatic signing and team `P2N837R7VM`. For a physical device, select a valid team/account in Xcode; do not commit personal provisioning profiles.

### No matching simulator

List installed devices and pass an exact device and OS pair:

```bash
xcrun simctl list devices available
mise exec -- tuist test run TuistTuistTuttoMondo \
  --device "<installed device name>" --os "<installed OS version>" \
  --no-selective-testing
```

### A change made in Xcode disappeared

If it was a project-setting, target-membership, dependency, or scheme change made inside the generated project, generation correctly discarded it. Reapply the intent in `Project.swift`. Source-code edits are ordinary files and remain intact.

## Further reading

- [Install Tuist](https://tuist.dev/en/docs/guides/install-tuist)
- [Migrate an Xcode project](https://tuist.dev/en/docs/guides/features/projects/adoption/migrate/xcode-project)
- [Project manifests](https://tuist.dev/en/docs/guides/features/projects/manifests)
- [Editing manifests](https://tuist.dev/en/docs/guides/features/projects/editing)
- [`tuist generate run`](https://tuist.dev/en/docs/cli/generate/run)
- [`tuist test run`](https://tuist.dev/en/docs/cli/test/run)
- [`tuist graph`](https://tuist.dev/en/docs/cli/graph)

The server-backed features are valuable later, but do not introduce them until you are comfortable reading this local target graph and regenerating it confidently.
