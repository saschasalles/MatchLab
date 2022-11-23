//
//  FeedViewController.swift
//  MatchLab
//
//  Created by Sascha Sallès on 09/11/2022.
//

import UIKit

final class FeedViewController: UIViewController {

    // MARK: - UI Attributes

    @IBOutlet private weak var containerStackView: UIStackView!

    // MARK: - UI Methods

    @IBAction private func didTapRefuseButton(_ sender: Any) {
        print("T'es moche")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function, self)
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print(#function, self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(#function, self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print(#function, self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        print(#function, self)
    }

    // MARK: - Private Methods

    private func configureUI() {
        containerStackView.layer.cornerRadius = 20
        containerStackView.clipsToBounds = true
        containerStackView.layer.cornerCurve = .circular
    }
}
