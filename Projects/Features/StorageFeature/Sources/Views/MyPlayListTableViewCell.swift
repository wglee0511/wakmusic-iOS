//
//  MyPlayListTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import DomainModule
import Kingfisher
import Utility

public protocol MyPlayListTableViewCellDelegate: AnyObject {
    func listTapped(indexPath: IndexPath)
}

class MyPlayListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playListImageView: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectButton: UIButton!
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func listSelectButtonAction(_ sender: Any) {
        delegate?.listTapped(indexPath: self.indexPath)
    }
    
    weak var delegate: MyPlayListTableViewCellDelegate?
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override var isEditing: Bool {
        didSet {
            updatePlayingState()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.playListImageView.layer.cornerRadius = 4
        self.playListNameLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.playListNameLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.playListCountLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playButton.setImage(DesignSystemAsset.Storage.play.image , for: .normal)
    }
}

extension MyPlayListTableViewCell {
    
    func update(model: PlayListEntity, isEditing: Bool, indexPath: IndexPath){
        self.playListImageView.kf.setImage(
            with: WMImageAPI.fetchPlayList(id: String(model.image),version: model.image_version).toURL,
            placeholder: nil,
            options: [.transition(.fade(0.2))])
           
        self.playListNameLabel.text = model.title
        self.playListCountLabel.text = "\(model.songlist.count)개"
        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        self.isEditing = isEditing
        self.listSelectButton.isHidden = !isEditing
        self.indexPath = indexPath
    }
    
    private func updatePlayingState() {
        if self.isEditing {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 오른쪽으로 사라지는 애니메이션
                guard let self else { return }
                self.playButton.alpha = 0
                self.playButton.transform = CGAffineTransform(translationX: 100, y: 0)
                self.playButtonTrailingConstraint.constant = -24
                self.layoutIfNeeded()

            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.playButton.isHidden = true
            })
        } else {
            self.playButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 다시 나타나는 애니메이ㄴ
                guard let self else { return }
                self.playButton.alpha = 1
                self.playButton.transform = .identity
                self.playButton.isHidden = false
                self.playButtonTrailingConstraint.constant = 20
                self.layoutIfNeeded()

            }, completion: { _ in
            })
        }
        
        self.listSelectButton.isHidden = !self.isEditing
    }
}

