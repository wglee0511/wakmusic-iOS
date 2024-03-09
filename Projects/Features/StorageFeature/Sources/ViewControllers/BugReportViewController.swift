//
//  SuggestFunctionViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import CommonFeature
import DesignSystem
import PhotosUI
import RxKeyboard
import RxSwift
import SafariServices
import UIKit
import Utility

// import Amplify
import Combine
import NVActivityIndicatorView

public final class BugReportViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var baseLine1: UIView!

    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var collectionContentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var attachContentView: UIView!
    @IBOutlet weak var attachLabel: UILabel!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!

    @IBOutlet weak var descriptionLabel3: UILabel!

    @IBOutlet weak var noticeCheckButton: UIButton!
    @IBOutlet weak var noticeSuperView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var noticeImageView: UIImageView!

    @IBOutlet weak var nickNameContentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var baseLine2: UIView!

    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!

    let unPointColor: UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor: UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let placeHolder: String = "내 답변"

    let placeHolderAttributes = [
        NSAttributedString.Key.foregroundColor: DesignSystemAsset.GrayColor.gray400.color,
        NSAttributedString.Key.font: DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    ] // 포커싱 플레이스홀더 폰트 및 color 설정

    let disposeBag = DisposeBag()

    var viewModel: BugReportViewModel!
    lazy var input = BugReportViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var keyboardHeight: CGFloat = 267
    var maxAttachedSize: Double = 30

    deinit {
        DEBUG_LOG("❌ \(Self.self) Deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCameraButtonUI()
        bindRx()
        bindbuttonEvent()
        responseViewbyKeyboard()
    }

    public static func viewController(viewModel: BugReportViewModel) -> BugReportViewController {
        let viewController = BugReportViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
}

extension BugReportViewController {
    private func configureCameraButtonUI() {
        let pointColor = DesignSystemAsset.PrimaryColor.decrease.color
        let cameraAttributedString = NSMutableAttributedString.init(string: "첨부하기")
        cameraAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: pointColor,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: cameraAttributedString.string.count)
        )
        attachLabel.attributedText = cameraAttributedString
        cameraImageView.image = DesignSystemAsset.Storage.camera.image

        attachContentView.layer.cornerRadius = 12
        attachContentView.layer.borderColor = pointColor.cgColor
        attachContentView.layer.borderWidth = 1
    }

    private func configureUI() {
        collectionView.delegate = self
        hideKeyboardWhenTappedAround()

        dotLabel.layer.cornerRadius = 2
        dotLabel.clipsToBounds = true
        dotLabel.backgroundColor = DesignSystemAsset.GrayColor.gray400.color

        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleLabel.text = "버그제보"
        titleLabel.setTextWithAttributes(kernValue: -0.5)

        descriptionLabel1.text = "겪으신 버그에 대해 설명해 주세요."
        descriptionLabel1.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel1.textColor = DesignSystemAsset.GrayColor.gray900.color
        descriptionLabel1.setTextWithAttributes(kernValue: -0.5)

        baseLine1.backgroundColor = unPointColor
        baseLine2.backgroundColor = unPointColor

        descriptionLabel2.text = "버그와 관련된 사진이나 영상을 첨부 해주세요."
        descriptionLabel2.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel2.textColor = DesignSystemAsset.GrayColor.gray900.color
        descriptionLabel2.setTextWithAttributes(kernValue: -0.5)

        descriptionLabel3.text = "왁물원 닉네임을 알려주세요."
        descriptionLabel3.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel3.textColor = DesignSystemAsset.GrayColor.gray900.color
        descriptionLabel3.setTextWithAttributes(kernValue: -0.5)

        scrollView.delegate = self
        textView.delegate = self
        textView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        textView.placeholder = placeHolder
        textView.placeholderColor = DesignSystemAsset.GrayColor.gray400.color
        textView.textColor = DesignSystemAsset.GrayColor.gray600.color
        textView.minHeight = 32.0
        textView.maxHeight = spaceHeight()

        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)

        noticeSuperView.layer.borderWidth = 1
        noticeSuperView.layer.cornerRadius = 12
        noticeSuperView.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor

        noticeLabel.text = "알려주기"
        noticeLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        noticeLabel.textColor = DesignSystemAsset.GrayColor.gray400.color
        noticeImageView.image = DesignSystemAsset.Navigation.close.image
        noticeLabel.setTextWithAttributes(kernValue: -0.5)

        textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: placeHolderAttributes)
        textField.textColor = DesignSystemAsset.GrayColor.gray600.color
        self.nickNameContentView.isHidden = true

        infoLabel.text = "닉네임을 알려주시면 피드백을 받으시는 데 도움이 됩니다."
        infoLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        infoLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        infoLabel.setTextWithAttributes(kernValue: -0.5)

        self.completionButton.layer.cornerRadius = 12
        self.completionButton.clipsToBounds = true
        self.completionButton.isEnabled = false
        self.completionButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.completionButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        self.completionButton.setAttributedTitle(NSMutableAttributedString(
            string: "완료",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard
                    .medium.font(size: 18),
                .foregroundColor: DesignSystemAsset
                    .GrayColor.gray25.color,
                .kern: -0.5
            ]
        ), for: .normal)

        self.previousButton.layer.cornerRadius = 12
        self.previousButton.clipsToBounds = true
        self.previousButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        self.previousButton.setAttributedTitle(NSMutableAttributedString(
            string: "이전",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium
                    .font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor
                    .gray25.color,
                .kern: -0.5
            ]
        ), for: .normal)

        self.loadingView.isHidden = true
        let loadingAttr = NSMutableAttributedString(
            string: "처리 중입니다.",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                .kern: -0.5
            ]
        )
        self.loadingLabel.attributedText = loadingAttr
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = UIColor.white
    }

    private func bindbuttonEvent() {
        previousButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)

        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)

        noticeCheckButton.rx.tap
            .withLatestFrom(input.publicNameOption)
            .subscribe(onNext: { [weak self] current in
                guard let self = self else { return }

                let vc = NickNamePopupViewController.viewController(
                    current: current.rawValue,
                    completion: { description in
                        let option = PublicNameOption(rawValue: description) ?? .nonDetermined
                        self.input.publicNameOption.accept(option)
                        self.nickNameContentView.isHidden = option != .public

                        if option != .public {
                            self.input.nickNameString.accept("")
                            self.textField.rx.text.onNext("")
                        }
                    }
                )
                self.showPanModal(content: vc)
            })
            .disposed(by: disposeBag)

        cameraButton.rx.tap
            .withLatestFrom(output.dataSource)
            .filter { [weak self] dataSource in
                guard let self else { return false }
                guard dataSource.count < 5 else {
                    self.showToast(
                        text: "첨부 파일은 최대 5개 까지 가능합니다.",
                        font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                    )
                    return false
                }
                return true
            }
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let library = UIAlertAction(title: "앨범", style: .default) { _ in
                    self.requestPhotoLibraryPermission()
                }
                let camera = UIAlertAction(title: "카메라", style: .default) { _ in
                    self.requestCameraPermission()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

                alert.addAction(library)
                alert.addAction(camera)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        completionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let vc = TextPopupViewController.viewController(
                    text: "작성하신 내용을 등록하시겠습니까?",
                    cancelButtonIsHidden: false,
                    completion: { [weak self] in
                        self?.input.completionButtonTapped.onNext(())
                        self?.loadingView.isHidden = false
                        self?.indicator.startAnimating()
                    }
                )
                self.showPanModal(content: vc)
            })
            .disposed(by: disposeBag)
    }

    private func bindRx() {
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.bugContentString)
            .disposed(by: disposeBag)

        let tfEditingDidBegin = textField.rx.controlEvent(.editingDidBegin)
        let tfEditingDidEnd = textField.rx.controlEvent(.editingDidEnd)

        let mergeObservable = Observable.merge(
            tfEditingDidBegin.map { UIControl.Event.editingDidBegin },
            tfEditingDidEnd.map { UIControl.Event.editingDidEnd }
        )

        textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.nickNameString)
            .disposed(by: disposeBag)

        mergeObservable
            .asObservable()
            .map { [weak self] event -> UIColor in
                guard let self = self else { return self?.unPointColor ?? DesignSystemAsset.GrayColor.gray200.color }
                return (event == .editingDidBegin) ? self.pointColor : self.unPointColor
            }
            .bind(to: baseLine2.rx.backgroundColor)
            .disposed(by: disposeBag)

        output.showCollectionView
            .bind(to: collectionContentView.rx.isHidden)
            .disposed(by: disposeBag)

        input.publicNameOption
            .do(onNext: { [weak self] option in
                guard let self = self else {
                    return
                }
                self.noticeLabel.textColor = option == .nonDetermined ? DesignSystemAsset.GrayColor.gray400
                    .color : DesignSystemAsset.GrayColor.gray900.color
            })
            .map { $0.rawValue }
            .bind(to: noticeLabel.rx.text)
            .disposed(by: disposeBag)

        output.enableCompleteButton
            .bind(to: completionButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.dataSource
            .skip(1)
            .bind(to: collectionView.rx.items) { [weak self] collectionView, index, model -> UICollectionViewCell in
                guard let self else { return UICollectionViewCell() }
                let indexPath = IndexPath(item: index, section: 0)
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "BugReportCollectionViewCell",
                    for: indexPath
                ) as? BugReportCollectionViewCell
                else {
                    return UICollectionViewCell()
                }
                cell.update(model: model, index: indexPath.row)
                cell.delegate = self
                return cell
            }.disposed(by: disposeBag)

        output.result
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] res in
                guard let self else { return }
                self.loadingView.isHidden = true
                self.indicator.stopAnimating()

                let vc = TextPopupViewController.viewController(
                    text: res.message ?? "오류가 발생했습니다.",
                    cancelButtonIsHidden: true,
                    completion: {
                        self.dismiss(animated: true)
                    }
                )
                self.showPanModal(content: vc)
            })
            .disposed(by: disposeBag)
    }

    private func responseViewbyKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                let safeAreaInsetsBottom: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
                let actualKeyboardHeight = max(0, keyboardVisibleHeight - safeAreaInsetsBottom)
                self.keyboardHeight = actualKeyboardHeight == .zero ? self.keyboardHeight : 300
                self.view.setNeedsLayout()

                UIView.animate(withDuration: 0, animations: {
                    self.scrollView.contentInset.bottom = actualKeyboardHeight
                    self.scrollView.verticalScrollIndicatorInsets.bottom = actualKeyboardHeight
                    self.view.layoutIfNeeded()
                })
            }).disposed(by: disposeBag)
    }

    func spaceHeight() -> CGFloat {
        return 16 * 10
    }

    private func showToastWithMaxSize() {
        let doubleToInt: Int = Int(self.maxAttachedSize)
        DispatchQueue.main.async {
            self.showToast(
                text: "첨부 파일의 용량은 최대 \(doubleToInt)MB 까지입니다.",
                font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
            )
        }
    }
}

extension BugReportViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.baseLine1.backgroundColor = self.pointColor
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.baseLine1.backgroundColor = self.unPointColor
    }
}

extension BugReportViewController: RequestPermissionable {
    public func showCamera() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        self.present(camera, animated: true, completion: nil)
    }

    public func showPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        let current = self.output.dataSource.value
        configuration.selectionLimit = 5 - current.count // 갯수 제한
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true)
    }
}

extension BugReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        let imageToData: Data = image.pngData() ?? Data()
        let sizeMB: Double = Double(imageToData.count).megabytes
        guard sizeMB <= self.maxAttachedSize else {
            self.showToastWithMaxSize()
            return
        }

        let curr = self.input.dataSource.value
        self.input.dataSource.accept(curr + [MediaDataType.image(data: imageToData)])
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension BugReportViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let maxAttachedSize: Double = self.maxAttachedSize

        results.forEach {
            let provider = $0.itemProvider

            if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) { // 동영상
                provider
                    .loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] fileURL, error in
                        guard let self = self, let url = fileURL else { return }

                        if let error = error {
                            DEBUG_LOG("error: \(error)")

                        } else {
                            DispatchQueue.global(qos: .userInteractive).async {
                                do {
                                    let data = try Data(contentsOf: url)
                                    DEBUG_LOG("Video: \(data)")
                                    let sizeMB: Double = Double(data.count).megabytes
                                    guard sizeMB <= maxAttachedSize else {
                                        self.showToastWithMaxSize()
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        let curr = self.input.dataSource.value
                                        self.input.dataSource.accept(curr + [MediaDataType.video(data: data, url: url)])
                                    }
                                } catch let error {
                                    DEBUG_LOG("error: \(error)")
                                }
                            }
                        }
                    }
            } else if provider.canLoadObject(ofClass: UIImage.self) { // 이미지
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    if let error = error {
                        DEBUG_LOG("error: \(error)")

                    } else {
                        DispatchQueue.main.async {
                            guard let image = image as? UIImage,
                                  let imageToData = image.pngData() else { return }
                            DEBUG_LOG("Image: \(imageToData)")
                            let sizeMB: Double = Double(imageToData.count).megabytes
                            guard sizeMB <= maxAttachedSize else {
                                self.showToastWithMaxSize()
                                return
                            }
                            let curr = self.input.dataSource.value
                            self.input.dataSource.accept(curr + [MediaDataType.image(data: imageToData)])
                        }
                    }
                }
            }
        }
    }
}

extension BugReportViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 80.0, height: 80.0)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20) // 오른쪽 끝까지 왔을 때 , 벽에서 20 만큼 떨어짐
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 4.0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 4.0
    }
}

extension BugReportViewController: BugReportCollectionViewCellDelegate {
    func tapRemove(index: Int) {
        self.input.removeIndex.accept(index)
    }
}
