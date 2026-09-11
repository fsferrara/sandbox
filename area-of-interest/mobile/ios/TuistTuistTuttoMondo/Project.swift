import ProjectDescription

let project = Project(
    name: "TuistTuistTuttoMondo",
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
            dependencies: [
                .target(name: "GreetingKit"),
            ],
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
                    "GreetingKitTests",
                ]
            ),
            runAction: .runAction(
                configuration: .debug,
                executable: "TuistTuistTuttoMondo"
            )
        ),
    ]
)
