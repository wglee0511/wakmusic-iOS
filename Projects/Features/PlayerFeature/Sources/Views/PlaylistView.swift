//
//  PlaylistView.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import Utility
import DesignSystem
import SnapKit
import Then

public final class PlaylistView: UIView {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
    
    private lazy var contentView = UIView()
    
    private lazy var titleBarView: UIView = UIView()
    
    internal lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var titleLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 16)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "재생목록"
        $0.setLineHeight(lineHeight: 24)
        $0.textAlignment = .center
    }
    
    internal lazy var editButton = RectangleButton(type: .custom).then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setColor(isHighlight: false)
        $0.setTitle("편집", for: .normal)
        $0.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 12)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    internal lazy var playlistTableView = UITableView().then {
        $0.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 60
        $0.estimatedRowHeight = 60
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        $0.showsVerticalScrollIndicator = false
    }
    
    internal lazy var miniPlayerView = UIView().then {
        $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
    }
    
    internal lazy var totalPlayTimeView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray300.color
    }
    internal lazy var currentPlayTimeView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
    }
    
    internal lazy var thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailSmall.image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    internal lazy var repeatButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var playButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var prevButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.prevOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var nextButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.nextOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var shuffleButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension PlaylistView {
    private func configureUI() {
        self.configureSubViews()
        self.configureBackground()
        self.configureContent()
        self.configureTitleBar()
        self.configurePlaylist()
        self.configureMiniPlayer()
    }
    
    private func configureSubViews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        contentView.addSubview(titleBarView)
        titleBarView.addSubview(closeButton)
        titleBarView.addSubview(titleLabel)
        titleBarView.addSubview(editButton)
        contentView.addSubview(playlistTableView)
        contentView.addSubview(miniPlayerView)
        miniPlayerView.addSubview(thumbnailImageView)
        miniPlayerView.addSubview(totalPlayTimeView)
        totalPlayTimeView.addSubview(currentPlayTimeView)
        miniPlayerView.addSubview(repeatButton)
        miniPlayerView.addSubview(prevButton)
        miniPlayerView.addSubview(playButton)
        miniPlayerView.addSubview(nextButton)
        miniPlayerView.addSubview(shuffleButton)
    }
    
    private func configureBackground() {
        self.backgroundColor = .white // 가장 뒷배경
        let safeAreaBottomInset: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        backgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-safeAreaBottomInset)
        }
    }
    
    private func configureContent() {
        let safeAreaBottomInset: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Utility.STATUS_BAR_HEGHIT())
            $0.bottom.equalToSuperview().offset(-safeAreaBottomInset)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureTitleBar() {
        titleBarView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    private func configurePlaylist() {
        playlistTableView.snp.makeConstraints {
            $0.top.equalTo(titleBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-56)
        }
    }
    
    private func configureMiniPlayer() {
        miniPlayerView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.left.right.equalToSuperview()
        }
        
        totalPlayTimeView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.left.right.equalToSuperview()
        }
        
        currentPlayTimeView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0)
        }
        
        let height = 40
        let width = height * 16 / 9
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        
        repeatButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(thumbnailImageView.snp.right).offset(27)
        }
        
        prevButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(repeatButton.snp.right).offset(20)
        }
        
        playButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(prevButton.snp.right).offset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(playButton.snp.right).offset(20)
        }
        
        shuffleButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(nextButton.snp.right).offset(20)
        }
    }
}