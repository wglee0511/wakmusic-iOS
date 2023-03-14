//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct RecommendPlayListEntity: Equatable {
    public init(
        id: String,
        title: String,
        `public`: Bool,
        image_round_version:Int
    ) {
        self.id = id
        self.title = title
        self.public = `public`
        self.image_round_version = image_round_version
    }
    
    public let id, title : String
    public let `public` : Bool
    public let image_round_version : Int
}
