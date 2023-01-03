import UIKit
import Utility
import DesignSystem

open class MainContainerViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tabBarCoverView: UIView!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var panelViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var panelViewHeightConstraint: NSLayoutConstraint!

    var originalPanelAlpha: CGFloat = 0
    var originalPanelPosition: CGFloat = 0
    var lastPoint: CGPoint = .zero
    var originalTabBarPosition: CGFloat = 0

    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self,
                                             action: #selector(panGesture(_:)))
        self.panelView.addGestureRecognizer(gesture)
        return gesture
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController() -> MainContainerViewController {
        let viewController = MainContainerViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

extension MainContainerViewController {

    @objc
    func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {

        let point = gestureRecognizer.location(in: self.view)
        let direction = gestureRecognizer.direction(in: self.view)
//        let velocity = gestureRecognizer.velocity(in: self.view)

        let window: UIWindow? = UIApplication.shared.windows.first
        let safeAreaInsetsTop: CGFloat = window?.safeAreaInsets.top ?? 0
        let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
        var statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        if safeAreaInsetsTop > statusBarHeight {
            statusBarHeight = safeAreaInsetsTop
        }

        let screenHeight = APP_HEIGHT() - (statusBarHeight + safeAreaInsetsBottom)
        let centerRatio = (-panelViewTopConstraint.constant + originalPanelPosition) /
                            (screenHeight + originalPanelPosition)

        switch gestureRecognizer.state {

        case .began:
            return

        case .changed:
            let yDelta = point.y - lastPoint.y

            var newConstant = panelViewTopConstraint.constant + yDelta
            newConstant = newConstant > originalPanelPosition ? originalPanelPosition : newConstant
            newConstant = newConstant < -screenHeight ? -screenHeight : newConstant

            self.panelViewTopConstraint.constant = newConstant

        case .ended:
            let standard: CGFloat = direction.contains(.Down) ? 1.0 : direction.contains(.Up) ? 0.0 : 0.5
            self.panelViewTopConstraint.constant = (centerRatio < standard) ? self.originalPanelPosition : -screenHeight

            UIView.animate(withDuration: 0.35,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.8,
                           options: [.curveEaseInOut],
                           animations: {

                self.tabBarHeightConstraint.constant = (centerRatio < standard) ? self.originalTabBarPosition : 0
                self.view.layoutIfNeeded()

            }, completion: { _ in
                self.tabBarCoverView.isHidden = (centerRatio < standard) ? true : false
            })

        default:
            return
        }

        self.lastPoint = point
    }

    private func configureUI() {

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarCoverView.isHidden = true

        let viewController = MainTabBarController.viewController()
        self.addChild(viewController)
        viewController.didMove(toParent: self)

        _ = panGestureRecognizer

        self.originalTabBarPosition = self.tabBarHeightConstraint.constant // 49
        self.originalPanelPosition = self.panelViewTopConstraint.constant // -56
        self.originalPanelAlpha = self.panelView.alpha
        self.panelView.isHidden = false
        self.view.layoutIfNeeded()
    }
}