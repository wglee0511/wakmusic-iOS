//
//  FetchLyricsTransfer.swift
//  NetworkModule
//
//  Created by YoungK on 2023/02/22.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Foundation
import Utility

public extension LyricsResponseDTO {
    func toDomain() -> LyricsEntity {
        LyricsEntity(
            identifier: identifier,
            start: start,
            end: end,
            text: text,
            styles: styles
        )
    }
}
