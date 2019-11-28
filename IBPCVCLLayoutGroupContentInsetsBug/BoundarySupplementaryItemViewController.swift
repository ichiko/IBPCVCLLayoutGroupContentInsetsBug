import UIKit
import IBPCollectionViewCompositionalLayout
import DiffableDataSources

class BoundarySupplementaryItemViewController: UIViewController {
    static let headerKind = "headerKind"
    static let footerKind = "footerKind"
    static let leadingKind = "leadingKind"
    static let trailingKind = "trailingKind"

    enum Section: Int, CaseIterable {
        case alignTop, alignBottom, alignLeading, alignTailing
    }

    var dataSource: CollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "BoundarySupplementaryItem.align"
        view.backgroundColor = .white
        configureHierarchy()
        configureDataSource()
    }
}

extension BoundarySupplementaryItemViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)

        collectionView.backgroundColor = .white
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        collectionView.register(HeaderFooterView.self, forSupplementaryViewOfKind: BoundarySupplementaryItemViewController.headerKind, withReuseIdentifier: HeaderFooterView.reuseIdentifier)
        collectionView.register(HeaderFooterView.self, forSupplementaryViewOfKind: BoundarySupplementaryItemViewController.footerKind, withReuseIdentifier: HeaderFooterView.reuseIdentifier)
        collectionView.register(HeaderFooterView.self, forSupplementaryViewOfKind: BoundarySupplementaryItemViewController.leadingKind, withReuseIdentifier: HeaderFooterView.reuseIdentifier)
        collectionView.register(HeaderFooterView.self, forSupplementaryViewOfKind: BoundarySupplementaryItemViewController.trailingKind, withReuseIdentifier: HeaderFooterView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0).isActive = true
        collectionView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func configureDataSource() {
        dataSource = CollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell else { fatalError("Could not create new cell") }

            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .blue
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.textColor = .white
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)

            return cell
        }

        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath
            ) -> UICollectionReusableView? in

            // Get a supplementary view of the desired kind.
            if let titleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderFooterView.reuseIdentifier,
                for: indexPath) as? HeaderFooterView {

                switch kind {
                case BoundarySupplementaryItemViewController.footerKind:
                    titleView.title = "Footer"
                case BoundarySupplementaryItemViewController.headerKind:
                    titleView.title = "Header"
                case BoundarySupplementaryItemViewController.leadingKind:
                    titleView.title = "Leading"
                case BoundarySupplementaryItemViewController.trailingKind:
                    titleView.title = "Trailing"
                default:
                    ()
                }
                return titleView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }

        var snapshot = DiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.alignTop])
        snapshot.appendItems([1, 2, 3])
        snapshot.appendSections([.alignBottom])
//        snapshot.appendItems([11, 12, 13])
        snapshot.appendSections([.alignLeading])
        snapshot.appendItems([21, 22, 23])
        dataSource.apply(snapshot)
    }


    private func createLayout() -> UICollectionViewLayout {
        let itemSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = IBPNSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = IBPNSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .absolute(50))
        let group = IBPNSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.edgeSpacing = IBPNSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil, trailing: nil, bottom: nil)

        let footerHeaderSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let leftSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1),
                                              heightDimension: .absolute(150.0))
        let header = IBPNSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
                                                                    elementKind: BoundarySupplementaryItemViewController.headerKind,
                                                                 alignment: .top)
        let footer = IBPNSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
                                                                    elementKind: BoundarySupplementaryItemViewController.footerKind,
                                                                 alignment: .bottom)
        let left = IBPNSCollectionLayoutBoundarySupplementaryItem(layoutSize: leftSize,
                                                                  elementKind: BoundarySupplementaryItemViewController.leadingKind,
                                                               alignment: .leading)
        let right = IBPNSCollectionLayoutBoundarySupplementaryItem(layoutSize: leftSize,
                                                                   elementKind: BoundarySupplementaryItemViewController.trailingKind,
                                                                   alignment: .trailing)
        let section = IBPNSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer, left, right]

        let config = IBPUICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        let layout = IBPUICollectionViewCompositionalLayout(section: section, configuration: config)

        return layout
    }
}
