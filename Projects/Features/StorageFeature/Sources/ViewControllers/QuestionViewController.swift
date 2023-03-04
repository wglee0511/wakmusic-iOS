//
//  QuestionViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/04.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift
import Utility

public final class QuestionViewController: UIViewController,ViewControllerFromStoryBoard {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bugReportSuperView: UIView!
    @IBOutlet weak var bugReportButton: UIButton!
    @IBOutlet weak var bugReportCheckImageView: UIImageView!
    
    @IBOutlet weak var suggestFunctionSuperView: UIView!
    @IBOutlet weak var suggestFunctionButton: UIButton!
    @IBOutlet weak var suggestFunctionCheckImageView: UIImageView!
    
    @IBOutlet weak var addSongSuperView: UIView!
    @IBOutlet weak var addSongButton: UIButton!
    @IBOutlet weak var addSongCheckImageView: UIImageView!
    
    @IBOutlet weak var editSongSuperView: UIView!
    @IBOutlet weak var editSongButton: UIButton!
    @IBOutlet weak var editSongCheckImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    let selectedColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let unSelectedTextColor:UIColor = DesignSystemAsset.GrayColor.gray900.color
    let unSelectedColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    public static func viewController() -> QuestionViewController {
        let viewController = QuestionViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        

        
        return viewController
    }


}


extension QuestionViewController {
    
    private func configureUI(){
        
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        self.closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        self.descriptionLabel.text = "어떤 것 관련해서 문의주셨나요?"
        self.descriptionLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 20)
        self.descriptionLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        self.nextButton.layer.cornerRadius = 12
        self.nextButton.clipsToBounds = true
        self.nextButton.isEnabled = false
        self.nextButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.nextButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        self.nextButton.setAttributedTitle(NSMutableAttributedString(string:"다음",
                                                                     attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                                                                  .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
        
        
            
        let superViews:[UIView] = [self.bugReportSuperView,self.suggestFunctionSuperView,self.addSongSuperView,self.editSongSuperView]
        
        let buttons:[UIButton] = [self.bugReportButton,self.suggestFunctionButton,self.addSongButton,self.editSongButton]
        
       // let imageViews:[UIImageView] = [self.bugReportCheckImageView,self.suggestFunctionCheckImageView,self.addSongCheckImageView,self.editSongCheckImageView]
        
        
        for i in 0...3 {
            
            superViews[i].layer.cornerRadius = 12
            superViews[i].layer.borderColor = unSelectedColor.cgColor
            superViews[i].layer.borderWidth = 1
            
            var title:String = ""
            
            switch i {
            case 0:
                title = "버그 제보"
            
            case 1:
                title = "기능 제안"
            
            case 2:
                title = "노래 추가"
                
            case 3:
                title = "노래 수정"
                
            default:
                return

            }
            
            buttons[i].setAttributedTitle(NSMutableAttributedString(string:title,
                                                                    attributes: [.font: DesignSystemFontFamily.Pretendard.light.font(size: 16),
                                                                                 .foregroundColor: unSelectedTextColor ]), for: .normal)
            
            
            
        }
        
        
        
        
    }
    
}
