# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS experimental project for observing and understanding SwiftUI view lifecycle events. The app demonstrates different view presentation patterns (modal, navigation, tab views, full-screen covers, and nested components) and logs their lifecycle events using a centralized logging utility.

## Building and Running

This project uses Xcode and requires the xcodebuildmcp MCP server to be configured.

**Set up the Xcode project session:**
```
session-set-defaults { "projectPath": "/full/path/to/ViewsLifecycle.xcodeproj", "scheme": "ViewsLifecycle" }
```

**Build and run on iOS Simulator:**
```
build_run_sim({ simulatorName: "iPhone 16" })
```

**Build for iOS Simulator:**
```
build_sim()
```

**List available simulators:**
```
list_sims()
```

**Clean build products:**
```
clean()
```

## Architecture

### Entry Point
- `ViewsLifecycleApp.swift`: Main app entry point that displays `MenuView` as the root view

### Core Structure
The app follows a simple navigation pattern where all demo views are accessible from the main menu:

**MenuView** (MenuView.swift:3-61)
- Root view containing a TabView with three tabs
- Home tab includes buttons to trigger different view presentation types:
  - Modal sheet (`.sheet` modifier)
  - Full-screen cover (`.fullScreenCover` modifier)
  - Navigation links to ComponentsView and NavView
- Additional tabs (Tab 1, Tab 2) use TabViewContent for lifecycle observation

**View Types Demonstrated:**
- **ModalView**: Simple modal presentation via `.sheet`
- **FullScreenCoverView**: Full-screen modal via `.fullScreenCover`
- **NavView**: Navigation stack demonstration
- **ComponentsView**: Parent view containing nested child components (Component1, Component2)
- **TabViewContent**: Reusable content for tab views

### Lifecycle Logging
**LifecycleLogger** (LifecycleLogger.swift:3-7)
- Centralized utility for logging view lifecycle events
- All views use `.onAppear` and `.onDisappear` modifiers to track lifecycle
- Logs include timestamp, view name, and event type
- Example: `LifecycleLogger.log("ModalView", event: "onAppear")`

### Key Patterns
- Every view implements lifecycle logging via `.onAppear` and `.onDisappear`
- Nested views log independently, allowing observation of parent-child lifecycle behavior
- MenuView logs both TabView and NavigationView lifecycle events separately to observe nested container behavior
