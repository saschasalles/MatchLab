//
//  MatchesViewController.swift
//  MatchLab
//
//  Created by Sascha Sallès on 07/12/2022.
//

import UIKit

final class MatchesViewController: UIViewController {

    // MARK: - Private Properties

    // MARK: Data

    private var profiles: [Profile]! {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: Navigation

    private enum PresentationMode {
        case list
        case grid
    }

    private var currentMode: PresentationMode = .list {
        didSet {
            guard currentMode != oldValue else { return }
            setBarButtonItem()
            updateCollectionViewLayout()
        }
    }

    private let listImage = UIImage(systemName: "list.bullet")

    private let gridImage = UIImage(systemName: "square.grid.2x2")

    private func setBarButtonItem() {
        let item = UIBarButtonItem(
            image: currentMode == .list ? listImage : gridImage,
            primaryAction: nil,
            menu: makeMenu()
        )

        navigationItem.rightBarButtonItem = item
    }

    private func makeMenu() -> UIMenu {
        let actions: [UIAction] = [
            UIAction(
                title: "List",
                state: currentMode == .list ? .on : .off,
                handler: { [weak self] _ in
                    self?.currentMode = .list
                }
            ),
            UIAction(
                title: "Grid",
                state: currentMode == .grid ? .on : .off,
                handler: { [weak self] _ in
                    self?.currentMode = .grid
                }
            )
        ]

        let menu = UIMenu(
            title: "Display Mode",
            image: nil,
            children: actions
        )

        return menu
    }

    // MARK: Collection View

    private let padding: CGFloat = 16

    private lazy var gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - padding * 2, height: 180)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: 10, left: padding, bottom: 10, right: padding)

        return layout
    }()

    private lazy var listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - padding * 2, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: padding, bottom: 10, right: padding)

        return layout
    }()

    private func updateCollectionViewLayout() {
        collectionView.reloadSections([0])

        collectionView.setCollectionViewLayout(
            currentMode == .list ? listLayout : gridLayout,
            animated: false
        )
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: listLayout
        )

        collectionView.register(
            MatchesGridCollectionViewCell.self,
            forCellWithReuseIdentifier: MatchesGridCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            MatchesListCollectionViewCell.self,
            forCellWithReuseIdentifier: MatchesListCollectionViewCell.reuseIdentifier
        )

        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        profiles = getMatchedProfiles()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        profiles = getMatchedProfiles()
        collectionView.reloadData()
    }

    // MARK: - Private Methods

    private func configureUI() {
        view.addSubview(collectionView)

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Matches"
        setBarButtonItem()

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    private func getMatchedProfiles() -> [Profile] {
        Profile.all.filter(\.wasMatched)
    }
}

// MARK: - CollectionViewDataSource

extension MatchesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let profile = profiles[indexPath.row]

        switch currentMode {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MatchesListCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? MatchesListCollectionViewCell else {
                return UICollectionViewCell()
            }

            if profile == profiles.first {
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner
                ]
                cell.contentView.layer.cornerRadius = 12
                cell.contentView.layer.cornerCurve = .continuous
            } else if profile == profiles.last {
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner
                ]
                cell.contentView.layer.cornerCurve = .continuous
                cell.contentView.layer.cornerRadius = 12
            } else {
                cell.contentView.layer.cornerRadius = 0
            }

            cell.configure(profile: profile)
            return cell

        case .grid:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MatchesGridCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? MatchesGridCollectionViewCell

            cell?.configure(profile: profile)
            return cell ?? UICollectionViewCell()
        }
    }
}

// MARK: - CollectionViewDelegate

extension MatchesViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let profile = profiles[indexPath.row]
        let profileInfoViewController = ProfileInfoViewController(profile: profile)

        profileInfoViewController.modalPresentationStyle = .overFullScreen
        profileInfoViewController.modalTransitionStyle = .crossDissolve

        present(profileInfoViewController, animated: true)
    }
}
