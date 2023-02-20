//
//  ArtistRepository.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import ErrorModule

public protocol UserRepository {
    func fetchProfileList() -> Single<[ProfileListEntity]>
    func setProfile(image:String) -> Single<BaseEntity>
    func setUserName(name:String) -> Single<BaseEntity>
    func fetchSubPlayList() -> Single<[SubPlayListEntity]>
    func fetchFavoriteSongs() -> Single<[FavoriteSongEntity]>

}