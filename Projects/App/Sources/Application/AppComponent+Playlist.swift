//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule
import SearchFeature

//MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함
// 

public extension AppComponent {
    
    var beforeSearchComponent : BeforeSearchComponent {
        
        BeforeSearchComponent(parent: self)
        
    }
    
    var remotePlayListDataSource: any RemotePlayListDataSource {
        shared {
            RemotePlayListDataSourceImpl(keychain: keychain)
        }
    }
    var playListRepository: any PlayListRepository {
        shared {
            PlayListRepositoryImpl(remotePlayListDataSource:remotePlayListDataSource)
        }
    }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase {
        
        shared {
          FetchRecommendPlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }
}
