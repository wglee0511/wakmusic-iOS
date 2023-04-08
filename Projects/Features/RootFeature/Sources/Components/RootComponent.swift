import UIKit
import MainTabFeature
import NeedleFoundation
import DomainModule

public protocol RootDependency: Dependency {
    var mainContainerComponent: MainContainerComponent { get }
    var permissionComponent: PermissionComponent { get }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase {get}
}

public final class RootComponent: Component<RootDependency> {
    public func makeView() -> IntroViewController {
        return IntroViewController.viewController(
            mainContainerComponent: dependency.mainContainerComponent,
            permissionComponent: dependency.permissionComponent,
            viewModel: IntroViewModel(fetchUserInfoUseCase: dependency.fetchUserInfoUseCase)
        )
    }
}