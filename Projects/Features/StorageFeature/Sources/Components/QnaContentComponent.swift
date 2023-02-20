//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import DomainModule

public protocol QnaContentDependency: Dependency {

}

public final class QnaContentComponent: Component<QnaContentDependency> {
    public func makeView(dataSource:[QnaEntity]) -> QnaContentViewController {
        return QnaContentViewController.viewController(viewModel: .init(dataSource: dataSource))
    }
}