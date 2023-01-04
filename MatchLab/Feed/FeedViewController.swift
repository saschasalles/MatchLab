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

    fileprivate enum SwipeDirection {
        case left
        case right
    }

    // MARK: - UI Attributes

    @IBOutlet private weak var imageView: UIImageView!

    @IBOutlet private weak var bannerView: UIView!

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var containerStackView: UIStackView!

    @IBOutlet private weak var matchButton: UIButton!

    @IBOutlet private weak var refuseButton: UIButton!

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recog = UIPanGestureRecognizer(target: self, action: #selector(dragCard(_:)))

        return recog
    }()

    private lazy var swipeRightGestureRecognizer: UISwipeGestureRecognizer = {
        let recog = UISwipeGestureRecognizer(target: self, action: #selector(didRightSwipeCard(_:)))
        recog.direction = .right
        return recog
    }()

    private lazy var swipeLeftGestureRecognizer: UISwipeGestureRecognizer = {
        let recog = UISwipeGestureRecognizer(target: self, action: #selector(didLeftSwipeCard(_:)))
        recog.direction = .left
        return recog
    }()

    private lazy var hapticGenerator = UIImpactFeedbackGenerator(style: .soft)

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

        configureUI()
        nextProfile()
    }

    // MARK: - Private Methods

    private func configureUI() {
        containerStackView.layer.cornerRadius = 20
        containerStackView.clipsToBounds = true
        containerStackView.layer.cornerCurve = .continuous

        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        imageView.layer.cornerCurve = .continuous
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        bannerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bannerView.layer.cornerRadius = 20
        bannerView.layer.cornerCurve = .continuous

        imageView.addGestureRecognizer(swipeLeftGestureRecognizer)
        imageView.addGestureRecognizer(swipeRightGestureRecognizer)
        hapticGenerator.prepare()
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
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.imageView.image = UIImage(systemName: "smiley")
                self?.imageView.contentMode = .scaleAspectFit
                self?.hapticGenerator.impactOccurred(intensity: 1.0)
            }
        )
        imageView.isUserInteractionEnabled = false
        matchButton.isEnabled = false
        refuseButton.isEnabled = false
        bannerView.isHidden = true
    }

    @objc func dragCard(_ sender: UIPanGestureRecognizer) {
        guard let senderView = sender.view  else {
            print("no data")
            return
        }

        let translation = sender.translation(in: senderView.superview)

        switch sender.state {
        case .began:
            print("- began -")
            hideBanner()
        case .changed:

            let rotationTransform = CGAffineTransform(rotationAngle: translation.x * .pi / 180)
            senderView.transform = rotationTransform

        case .failed, .cancelled:
            showBanner { [weak self] in
                self?.resetCardPosition(senderView)
            }
        case .possible:
            print("possible")
        case .ended:
            showBanner { [weak self] in
                self?.resetCardPosition(senderView)
            }
        @unknown default:
            return
        }
    }

    @objc func didRightSwipeCard(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            swipeCard(direction: .right)
        }
    }

    @objc func didLeftSwipeCard(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            swipeCard(direction: .left)
        }
    }

    private func swipeCard(direction: SwipeDirection) {
        UIView.animate(
            withDuration: 0.15,
            delay: .zero,
            options: [.curveEaseIn],
            animations: { [weak self] in
                guard let self else { return }
                self.containerStackView.isUserInteractionEnabled = false
                self.bannerView.alpha = .zero
                self.imageView.alpha = .zero
                let midScreenTranslate = self.view.bounds.midX
                let transform = CGAffineTransform(
                    translationX: direction == .left ? -midScreenTranslate : midScreenTranslate,
                    y: 0
                )

                var rotation = CGAffineTransform(
                    rotationAngle: 10 * .pi / 180
                )

                rotation = direction == .left ? rotation.inverted() : rotation

                self.bannerView.transform = transform.concatenating(rotation)
                self.imageView.transform = transform.concatenating(rotation)
            },
            completion: { [weak self] _ in
                guard let self else { return }

                if direction == .right { self.matchProfile() }
                self.nextProfile()

                self.containerStackView.isUserInteractionEnabled = true
                self.bannerView.alpha = 1
                self.imageView.alpha = 1
                self.imageView.isHidden = false
                self.imageView.transform = .identity
                self.bannerView.transform = .identity
                self.hapticGenerator.impactOccurred()
            }
        )
    }

    private func resetCardPosition(_ card: UIView) {
        UIView.animate(withDuration: 0.1) {
            card.transform = .identity
        }
    }

    private func showBanner(completionHandler: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.1,
            animations: { [weak self] in
                self?.bannerView.alpha = 1
                self?.bannerView.isHidden = false
            },
            completion: { _ in
                completionHandler()
            }
        )
    }

    private func hideBanner(completionHandler: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.1,
            delay: .zero,
            options: [.curveLinear],
            animations: { [weak self] in
                self?.bannerView.alpha = 0
            },
            completion: { [weak self] _ in
                self?.bannerView.isHidden = true
                completionHandler?()
            }
        )
    }
}
