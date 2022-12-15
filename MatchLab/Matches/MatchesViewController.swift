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
            tableView.reloadData()
        }
    }

    private let cellReuseIdentifier = "matchedProfileCellReuseIdentifier"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
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
        tableView.reloadData()
    }

    // MARK: - Private Methods

    private func configureUI() {
        view.addSubview(tableView)

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Matches"

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    private func getMatchedProfiles() -> [Profile] {
        Profile.all.filter(\.wasMatched)
    }
}

// MARK: - TableViewDataSource

extension MatchesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            return UITableViewCell()
        }

        let profile = profiles[indexPath.row]
        cell.textLabel?.text = profile.name

        return cell
    }
}

// MARK: - TableViewDelegate

extension MatchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let profile = profiles[indexPath.row]
        let profileInfoViewController = ProfileInfoViewController(profile: profile)

        profileInfoViewController.modalPresentationStyle = .overFullScreen
        profileInfoViewController.modalTransitionStyle = .crossDissolve

        present(profileInfoViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Remove by Gass", handler: { [weak self] _, _, _ in
                guard let self else { return }
                let profileName = self.profiles[indexPath.row].name
                self.profiles = self.profiles.filter({ $0.name != profileName })
            })
        ])
    }
}
