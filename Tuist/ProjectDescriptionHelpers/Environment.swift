import ProjectDescription

public enum Environment {
    public static let appName = "WaktaverseMusic"
    public static let targetName = "WaktaverseMusic"
    public static let beforeName = "Billboardoo"
    public static let targetTestName = "\(targetName)Tests"
    public static let organizationName = "yongbeomkwak"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone])
    public static let platform = Platform.iOS
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
        .marketingVersion("2.0.2")
        .currentProjectVersion("2")
        .debugInformationFormat(DebugInformationFormat.dwarfWithDsym)
        .otherLinkerFlags(["-ObjC"])
        .bitcodeEnabled(false)
}
