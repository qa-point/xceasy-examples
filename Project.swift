import ProjectDescription

let xceasyPackage: Package = Environment.xceasyUseLocalPackage.getBoolean(default: false)
    ? .local(path: "../xceasy")
    : .remote(url: "https://github.com/qa-point/xceasy.git", requirement: .exact("0.1.3"))

let project = Project(
    name: "XCEasyExamples",
    organizationName: "qa-point",
    options: .options(
        automaticSchemesOptions: .disabled,
        disableSynthesizedResourceAccessors: true
    ),
    packages: [xceasyPackage],
    targets: [
        .target(
            name: "UIKitExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.qa-point.xceasy-examples.uikit",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": ""
                ]
            ]),
            sources: ["UIKitExample/Sources/**"],
            resources: ["UIKitExample/Resources/**"]
        ),
        .target(
            name: "UIKitExampleUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "com.qa-point.xceasy-examples.uikit-tests",
            deploymentTargets: .iOS("15.0"),
            sources: ["UIKitExample/UITests/**"],
            dependencies: [
                .target(name: "UIKitExample"),
                .package(product: "XCEasy")
            ]
        ),
        .target(
            name: "SwiftUIExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.qa-point.xceasy-examples.swiftui",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": ""
                ]
            ]),
            sources: ["SwiftUIExample/Sources/**"],
            resources: ["SwiftUIExample/Resources/**"]
        ),
        .target(
            name: "SwiftUIExampleUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "com.qa-point.xceasy-examples.swiftui-tests",
            deploymentTargets: .iOS("15.0"),
            sources: ["SwiftUIExample/UITests/**"],
            dependencies: [
                .target(name: "SwiftUIExample"),
                .package(product: "XCEasy")
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "UIKitExample",
            shared: true,
            buildAction: .buildAction(targets: ["UIKitExample"]),
            testAction: .testPlans(["TestPlans/UIKitExampleTestPlan.xctestplan"])
        ),
        .scheme(
            name: "SwiftUIExample",
            shared: true,
            buildAction: .buildAction(targets: ["SwiftUIExample"]),
            testAction: .testPlans(["TestPlans/SwiftUIExampleTestPlan.xctestplan"])
        )
    ]
)
