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
        nextProfile(matched: false)
    }

    @IBAction private func didTapMatchButton(_ sender: Any) {
        nextProfile(matched: true)
    }

    deinit {
        print(#function, self)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function, self)
        configureUI()
        nextProfile(matched: false)
    }

    // MARK: - Private Methods

    private func configureUI() {
        containerStackView.layer.cornerRadius = 20
        containerStackView.clipsToBounds = true
        containerStackView.layer.cornerCurve = .circular

        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        bannerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bannerView.layer.cornerRadius = 20
        bannerView.layer.cornerCurve = .continuous
    }

    private func nextProfile(matched: Bool) {
        guard !profiles.isEmpty, count < profiles.count else {
            userDidReachEnd()
            return
        }

        let profile = profiles[count]
        UIView.transition(
            with: imageView,
            duration: 0.4,
            options: .transitionFlipFromBottom,
            animations: { [weak self] in
                self?.imageView.image = UIImage(named: profile.imageName)
            }
        )

        UIView.transition(
            with: bannerView,
            duration: 0.35,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.titleLabel.text = profile.name
                self?.descriptionLabel.text = profile.description
            }
        )

        titleLabel.text = profile.name
        descriptionLabel.text = profile.description
        profile.setMatched(matched)

        count += 1
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
