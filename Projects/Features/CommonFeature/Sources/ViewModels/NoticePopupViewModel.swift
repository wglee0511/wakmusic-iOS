//
//  NoticePopupViewModel.swift
//  CommonFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import DataMappingModule
import Utility

public class NoticePopupViewModel {
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    var fetchNoticeEntities: [FetchNoticeEntity]
    
    public struct Input {
    }

    public struct Output {
        var dataSource: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    }
    
    public init(
        fetchNoticeEntities: [FetchNoticeEntity]
    ){
        
        //TO-DO: savedIgoreIDs
//        let savedIgoreIDs: [Int] = []
        self.fetchNoticeEntities = fetchNoticeEntities
        let images: [String] = self.fetchNoticeEntities.map { $0.images }.reduce([]){ $0 + $1 }
        let ids: [Int] = self.fetchNoticeEntities.map { $0.id }
        output.dataSource.accept(images)
    }
}
