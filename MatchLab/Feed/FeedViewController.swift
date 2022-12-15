//
//  FeedViewController.swift
//  MatchLab
//
//  Created by Sascha Sallès on 09/11/2022.
//

import UIKit

final class FeedViewController: UIViewController {

    // MARK: Private Properties

    private var profiles: [Profile] { Profile.all }

    private var count = 0

    // MARK: - UI Attributes

    @IBOutlet private weak var imageView: UIImageView!

    @IBOutlet private weak var bannerView: UIView!

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var containerStackView: UIStackView!

    @IBOutlet private weak var matchButton: UIButton!

    @IBOutlet private weak var refuseButton: UIButton!

    // MARK: - UI Methods

    @IBAction private func didTapRefuseButton(_ sender: Any) {
        nextProfile()
    }

    @IBAction private func didTapMatchButton(_ sender: Any) {
        matchProfile()
        nextProfile()
    }

    deinit {
        print(#function, self)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function, self)
        configureUI()
        nextProfile()
    }

    // MARK: - Private Methods

    private func configureUI() {
        containerStackView.layer.cornerRadius = 20
        containerStackView.clipsToBounds = true
        containerStackView.layer.cornerCurve = .continuous

        imageView.layer.cornerRadius = 20
        imageView.layer.cornerCurve = .continuous
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        bannerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bannerView.layer.cornerRadius = 20
        bannerView.layer.cornerCurve = .continuous
    }

    private func nextProfile() {
        guard !profiles.isEmpty, count < profiles.count else {
            userDidReachEnd()
            return
        }

        let profile = profiles[count]

        imageView.image = UIImage(named: profile.imageName)
        titleLabel.text = profile.name
        descriptionLabel.text = profile.description
        count += 1
    }

    func matchProfile() {
        guard !profiles.isEmpty else { return }
        profiles[count - 1].setMatched(true)
    }

    private func userDidReachEnd() {
        UIView.transition(
            with: imageView,
            duration: 0.35,
            options: .transitionCurlUp,
            animations: { [weak self] in
                self?.imageView.image = UIImage(systemName: "smiley")
                self?.imageView.contentMode = .scaleAspectFit
            }
        )

        matchButton.isEnabled = false
        refuseButton.isEnabled = false
        bannerView.isHidden = true
    }

}
