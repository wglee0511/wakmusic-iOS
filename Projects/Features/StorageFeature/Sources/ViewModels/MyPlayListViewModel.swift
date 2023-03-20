//
//  FavoriteViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import BaseFeature
import DomainModule
import Utility
import CommonFeature

public final class MyPlayListViewModel:ViewModelType {
    
    

    var disposeBag = DisposeBag()
    var fetchPlayListUseCase:FetchPlayListUseCase!
    var editPlayListOrderUseCase:EditPlayListOrderUseCase!
    
    public struct Input {
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let playListLoad:BehaviorRelay<Void> = BehaviorRelay(value: ())
        let cancelEdit:PublishSubject<Void> = PublishSubject()
        let runEditing:PublishSubject<Void> = PublishSubject()
        let showConfirmModal:PublishSubject<Void> = PublishSubject()
        let showErrorToast:PublishRelay<String> = PublishRelay()
        
    }

    public struct Output {
        let state:BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: true))
        let dataSource: BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource:BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
    }

    init(fetchPlayListUseCase:FetchPlayListUseCase,editPlayListOrderUseCase:EditPlayListOrderUseCase) {
        
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.editPlayListOrderUseCase = editPlayListOrderUseCase
        DEBUG_LOG("✅ MyPlayListViewModel 생성")
        
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        input.playListLoad
            .flatMap({ [weak self] () -> Observable<[PlayListEntity]> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                return self.fetchPlayListUseCase.execute()
                    .asObservable()
                    .catchAndReturn([])
            })
            .map { [MyPlayListSectionModel(model: 0, items: $0)] }
            .bind(to: output.dataSource,output.backUpdataSource)
            .disposed(by: disposeBag)
        
        
        input.runEditing.withLatestFrom(output.dataSource)
            .filter({!$0.isEmpty})
            .map { $0.first?.items.map { $0.key } ?? [] }
            .flatMap({[weak self] (ids:[String])  -> Observable<BaseEntity> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                
                
                return self.editPlayListOrderUseCase.execute(ids: ids)
                    .asObservable()
            }).subscribe(onNext: { [weak self] in
                
                guard let self = self else{
                    return
                }
                
                
                if $0.status != 200 {
                    input.showErrorToast.accept($0.description)
                    return
                }
                
                output.backUpdataSource.accept(output.dataSource.value)
                
                
            }).disposed(by: disposeBag)
        
      
        input.cancelEdit
            .withLatestFrom(output.backUpdataSource)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
        
        return output
        
    }
    
    
}
