//
//  MatchesViewController.swift
//  MatchLab
//
//  Created by Sascha Sallès on 07/12/2022.
//

import UIKit

final class MatchesViewController: UIViewController {

    // MARK: - Private Properties

    private var profiles: [Profile]! {
        didSet {
            collectionView.reloadData()
        }
    }

    let padding: CGFloat = 16

    private lazy var gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - padding * 2, height: 180)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: 10, left: padding, bottom: 10, right: padding)

        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: gridLayout
        )

        collectionView.register(
            MatchesGridCollectionViewCell.self,
            forCellWithReuseIdentifier: MatchesGridCollectionViewCell.reuseIdentifier
        )

        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self

//        collectionView.delegate = self

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
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return profiles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MatchesGridCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MatchesGridCollectionViewCell

        let profile = profiles[indexPath.row]
        cell?.configure(profile: profile)

        return cell ?? UICollectionViewCell()
    }
}

// MARK: - TableViewDelegate

//extension MatchesViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let profile = profiles[indexPath.row]
//        let profileInfoViewController = ProfileInfoViewController(profile: profile)
//
//        profileInfoViewController.modalPresentationStyle = .overFullScreen
//        profileInfoViewController.modalTransitionStyle = .crossDissolve
//
//        present(profileInfoViewController, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 55
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//        UISwipeActionsConfiguration(actions: [
//            UIContextualAction(style: .destructive, title: "Remove by Gass", handler: { [weak self] _, _, _ in
//                guard let self else { return }
//                let profileName = self.profiles[indexPath.row].name
//                self.profiles = self.profiles.filter({ $0.name != profileName })
//            })
//        ])
//    }
//}
