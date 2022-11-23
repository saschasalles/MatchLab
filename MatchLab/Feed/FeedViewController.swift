//
//  FeedViewController.swift
//  MatchLab
//
//  Created by Sascha Sallès on 09/11/2022.
//

import UIKit

final class FeedViewController: UIViewController {

    // MARK: - UI Attributes

    @IBOutlet private weak var imageView: UIImageView!

    @IBOutlet private weak var bannerView: UIView!

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var containerStackView: UIStackView!

    @IBOutlet private weak var matchButton: UIButton!
    
    // MARK: - UI Methods

    @IBAction private func didTapRefuseButton(_ sender: Any) {
        print("T'es moche")
    }

    @IBAction private func didTapMatchButton(_ sender: Any) {
        imageView.image = UIImage(named: "tln")
        matchButton.isEnabled = false
    }

    deinit {
        print(#function, self)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function, self)
        configureUI()
    }

    // MARK: - Private Methods

    private func configureUI() {
        containerStackView.layer.cornerRadius = 20
        containerStackView.clipsToBounds = true
        containerStackView.layer.cornerCurve = .circular

        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "gatien")
        imageView.contentMode = .scaleAspectFill

        bannerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bannerView.layer.cornerRadius = 20
        bannerView.layer.cornerCurve = .continuous

        titleLabel.text = "Gatien"
        descriptionLabel.text = "Gatien va payer sa tournée ce soir"


    }
}
