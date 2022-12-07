//
//  MatchesViewController.swift
//  MatchLab
//
//  Created by Sascha Sallès on 07/12/2022.
//

import UIKit

final class MatchesViewController: UIViewController {

    // MARK: - Private Properties

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getMatchedProfiles()
    }

    // MARK: - Private Methods

    private func configureUI() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

    }

    private func getMatchedProfiles() {
        let matchedProfiles = Profile.all.filter(\.wasMatched)
        print(matchedProfiles.map { $0.name })
    }
}
