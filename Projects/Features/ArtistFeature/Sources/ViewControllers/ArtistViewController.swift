import UIKit
import Utility
import DesignSystem
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import NeedleFoundation
import PDFKit

public final class ArtistViewController: BaseViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private var viewModel: ArtistViewModel!
    private lazy var input = ArtistViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    
    var artistDetailComponent: ArtistDetailComponent!

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindRx()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    public static func viewController(
        viewModel: ArtistViewModel,
        artistDetailComponent: ArtistDetailComponent
    ) -> ArtistViewController {
        let viewController = ArtistViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.artistDetailComponent = artistDetailComponent
        return viewController
    }
}

extension ArtistViewController {
    
    private func bindRx() {
        
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            })
            .bind(to: collectionView.rx.items) { (collectionView, index, model) -> UICollectionViewCell in
                let indexPath = IndexPath(item: index, section: 0)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistListCell",
                                                                    for: indexPath) as? ArtistListCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .do(onNext: { [weak self] (indexPath, _) in
                guard let `self` = self,
                      let cell = self.collectionView.cellForItem(at: indexPath) as? ArtistListCell else { return }
                cell.animateSizeDownToUp(timeInterval: 0.3)
            })
            .delay(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .map { $0.1[$0.0.row] }
            .subscribe(onNext:{ [weak self] (model) in
                guard let `self` = self else { return }
                let viewController = self.artistDetailComponent.makeView(model: model)
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        
        activityIndicator.startAnimating()
        
        let sideSpace: CGFloat = 20.0
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 15, left: sideSpace, bottom: 15, right: sideSpace)
//        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 8 // 열 사이의 간격
        layout.headerHeight = 0
        layout.footerHeight = 50.0
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.collectionView.showsVerticalScrollIndicator = false
    }
}

extension ArtistViewController: WaterfallLayoutDelegate {

    public func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let originWidth: CGFloat = 106.0
        let originHeight: CGFloat = 130.0
        let rate: CGFloat = originHeight/max(1.0, originWidth)

        let sideSpace: CGFloat = 8.0
        let width: CGFloat = APP_WIDTH() - ((sideSpace * 2.0) + 40.0)
        let spacingWithNameHeight: CGFloat = 4.0 + 24.0 + 40.0 + 15
        let imageHeight: CGFloat = width * rate
        
        switch indexPath.item {
        case 0, 2:
            return CGSize(width: width, height: (imageHeight) + (width / 2) + spacingWithNameHeight)

        default:
            return CGSize(width: width, height: (imageHeight) + spacingWithNameHeight)
        }
    }

    public func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 3, distributionMethod: .balanced)
    }
}