//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import SignInFeature
import DomainModule

public protocol FavoriteDependency: Dependency {
   
    var fetchFavoriteSongsUseCase:any FetchFavoriteSongsUseCase {get}
}

public final class FavoriteComponent: Component<FavoriteDependency> {
    public func makeView() -> FavoriteViewController {
        return FavoriteViewController.viewController(viewModel: .init(fetchFavoriteSongsUseCase: dependency.fetchFavoriteSongsUseCase))
    }
}