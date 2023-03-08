//
//  FavoriteViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxRelay
import DesignSystem
import RxSwift
import BaseFeature
import CommonFeature
import DomainModule

public final class FavoriteViewController: BaseViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    
    
  
    var viewModel: FavoriteViewModel!
    lazy var input = FavoriteViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    
    var disposeBag = DisposeBag()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
        configureUI()

        // Do any additional setup after loading the view.
    }
    

    public static func viewController(viewModel:FavoriteViewModel) -> FavoriteViewController {
        let viewController = FavoriteViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
      
        viewController.viewModel = viewModel
        
        return viewController
    }

}

extension FavoriteViewController{
    
    private func configureUI()
    {
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        tableView.backgroundColor = .clear
        
        bindRx()
        
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        
        
        if  !output.state.value.isEditing && sender.state == .began {
            output.state.accept(EditState(isEditing: true, force: true))
            HapticManager.shared.impact(style: .light)
        }
    }
    
    private func bindRx()
    {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        output.dataSource
        .do(onNext: { [weak self] model in
            
            guard let self = self else {
                return
            }
            
            let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT()/3))
            warningView.text = "좋아요 한 곡이 없습니다."
        
            
            self.tableView.tableHeaderView = model.isEmpty ?  warningView : nil
        })
            
            .bind(to: tableView.rx.items){[weak self] (tableView:UITableView,index:Int,model:FavoriteSongEntity) -> UITableViewCell in
                guard let self = self else{return UITableViewCell()}
                
                let bgView = UIView()
                bgView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.6)
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier:  "FavoriteTableViewCell", for: IndexPath(row: index, section: 0)) as? FavoriteTableViewCell
                else {return UITableViewCell()}
                 
                cell.selectedBackgroundView = bgView
                cell.update(model, self.output.state.value.isEditing)
              
                        
             return cell
            }.disposed(by: disposeBag)
        
        
            output.state
            .skip(1)
            .do(onNext: { [weak self] state in
               
                DEBUG_LOG(state)
               
                guard let self = self else{
                    return
                }
                
                if state.isEditing == false && state.force == false { // 정상적인 편집 완료 이벤트
                    self.input.runEditing.onNext(())
                }
                
                
                self.tableView.dragInteractionEnabled = state.isEditing // true/false로 전환해 드래그 드롭을 활성화하고 비활성화 할 것입니다.
                
                
    
                
                
                guard let parent = self.parent?.parent as? AfterLoginViewController else{
                    return
                }
                // 탭맨 쪽 편집 변경
                parent.output.state.accept(EditState(isEditing: state.isEditing, force: true))
                
                
            })
            .withLatestFrom(output.dataSource)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
    
        
            input.showConfirmModal.subscribe(onNext: { [weak self] in
                
                guard let self = self else{
                    return
                }
                
                
                let vc = TextPopupViewController.viewController(text: "변경된 내용을 저장할까요?", cancelButtonIsHidden: false,completion: {

                    self.input.runEditing.onNext(())
                    
                },cancelCompletion: {
                    
                    self.input.cancelEdit.onNext(())
                })
             
                self.showPanModal(content: vc)
                
            }).disposed(by: disposeBag)
                
                
                input.showErrorToast.subscribe(onNext: { [weak self] (msg:String) in
                    
                    guard let self = self else{
                        return
                    }
                    
                    self.showToast(text: msg, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
                    
                    
                }).disposed(by: disposeBag)
      
        
    }
    
}

extension FavoriteViewController:UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
        
}


extension  FavoriteViewController: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        
        self.input.sourceIndexPath.accept(indexPath)
        let itemProvider = NSItemProvider(object: "1" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
        
        
        // 애플의 공식 문서에서는 사용자가 특정 행을 드래그하는 것을 원하지 않으면 빈 배열을 리턴하라고 했는데,
        //빈 배열을 리턴했을 때도 드래그가 가능했습니다. 이 부분은 더 자세히 알아봐야 할 것 같습니다.
    }
    
    
    
    
}

extension  FavoriteViewController: UITableViewDropDelegate {
    
    
    // 손가락을 화면에서 뗐을 때. 드롭한 데이터를 불러와서 data source를 업데이트 하고, 필요하면 새로운 행을 추가한다.
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath

                if let indexPath = coordinator.destinationIndexPath {
                    destinationIndexPath = indexPath
                } else {
                    // Get last index path of table view.
                    let section = tableView.numberOfSections - 1
                    let row = tableView.numberOfRows(inSection: section)
                    destinationIndexPath = IndexPath(row: row, section: section)
                }
        self.input.destIndexPath.accept(destinationIndexPath)
        
        
        
        
        
        
        var curr = output.dataSource.value
        var tmp = curr[self.input.sourceIndexPath.value.row]
        curr.remove(at: self.input.sourceIndexPath.value.row)
        curr.insert(tmp, at: self.input.destIndexPath.value.row)
        output.dataSource.accept(curr)
        
        
        DEBUG_LOG(destinationIndexPath)
    }
    
    // 드래그할 떄 (손가락을 화면에 대고 있을 때)
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        var dropProposal = UITableViewDropProposal(operation: .cancel)
    
       
        // Accept only one drag item.
        guard session.items.count == 1 else { return dropProposal }
        
        // The .move drag operation is available only for dragging within this app and while in edit mode.
        if tableView.hasActiveDrag {
            //            if tableView.isEditing {
            dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            //            }
        } else {
            // Drag is coming from outside the app.
            dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        
        
        return dropProposal
    }
    
    
    
}
