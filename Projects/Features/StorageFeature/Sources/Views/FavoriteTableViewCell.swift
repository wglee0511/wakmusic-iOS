//
//  FavoriteTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import CommonFeature
import DomainModule
import Utility

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var isEdit:Bool = false
    
    
    

    @IBAction func playAxtion(_ sender: UIButton) {
        
        if !isEdit{
            print("Play")
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        
        self.albumImageView.layer.cornerRadius = 4

        
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.artistLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)

        
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.artistLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        
    }

}


extension FavoriteTableViewCell {
    
    public func update(_ model:FavoriteSongEntity,_ isEditing:Bool)
    {
        albumImageView.kf.setImage(with: WMImageAPI.fetchYoutubeThumbnail(id: model.song.id).toURL,placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,options: [.transition(.fade(0.2))])
        

        
        titleLabel.text =  model.song.title
        artistLabel.text = model.song.artist
        isEdit = isEditing
        
        button.setImage( isEditing ? DesignSystemAsset.Storage.move.image :  DesignSystemAsset.Storage.play.image, for: .normal)
    }
}
