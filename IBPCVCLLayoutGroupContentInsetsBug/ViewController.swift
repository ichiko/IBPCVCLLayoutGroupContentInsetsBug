//
//  ViewController.swift
//  IBPCVCLLayoutGroupContentInsetsBug
//
//  Created by ichiko-moro on 2019/10/25.
//  Copyright © 2019 ichiko-moro. All rights reserved.
//

import UIKit
import IBPCollectionViewCompositionalLayout
import DiffableDataSources

class TextCell: UICollectionViewCell {
    static let reuseIdentifier = "textCell"
    
    var label: UILabel! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        label = UILabel()
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.textAlignment = .center
    }
}

class ViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case one, two, three

        var columns: Int {
            switch self {
            case .one: return 1
            case .two: return 2
            case .three: return 3
            }
        }
    }

    var dataSource: CollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "group.contentInsets"
        configureHierarchy()
        configureDataSource()
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)

        collectionView.backgroundColor = .white
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
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
        
        var snapshot = DiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.one, .two, .three])
        snapshot.appendItems([1], toSection: .one)
        snapshot.appendItems([11, 12], toSection: .two)
        snapshot.appendItems([21, 22, 23], toSection: .three)
        dataSource.apply(snapshot)
    }
}

extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = IBPUICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex: Int, _: IBPNSCollectionLayoutEnvironment) -> IBPNSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }

            switch section {
            case .one: return ViewController.createOneColumnLayout()
            case .two: return ViewController.createTwoColumnLayout()
            case .three: return ViewController.createThreeColumnLayout()
            }
        })
        return layout
    }

    private static func createOneColumnLayout() -> IBPNSCollectionLayoutSection {
        let itemSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = IBPNSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
        let group = IBPNSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = IBPNSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let section = IBPNSCollectionLayoutSection(group: group)
        return section
    }

    private static func createTwoColumnLayout() -> IBPNSCollectionLayoutSection {
        let itemSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = IBPNSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
        let group = IBPNSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = IBPNSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let section = IBPNSCollectionLayoutSection(group: group)
        return section
    }

    private static func createThreeColumnLayout() -> IBPNSCollectionLayoutSection {
        let itemSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = IBPNSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = IBPNSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
        let group = IBPNSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.contentInsets = IBPNSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let section = IBPNSCollectionLayoutSection(group: group)
        return section
    }
}
