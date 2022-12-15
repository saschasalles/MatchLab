//
//  ProfileInfoViewController.swift
//  MatchLab
//
//  Created by Sascha Sallès on 07/12/2022.
//

import SwiftUI
import UIKit

struct ProfileInfoView: View {
    var profile: Profile

    var dismissAction: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
                Spacer()
                Button {
                    dismissAction()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                }
            }

            Image(profile.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .cornerRadius(10)
                .padding(.bottom)

            Text(profile.name)
                .font(.title)

            Text(profile.description)
                .font(.headline)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        )
        .edgesIgnoringSafeArea(.all)

    }

}

@available(iOS 13.0, *)
public struct VisualEffectView: UIViewRepresentable {

    // MARK: Private Properties

    private var effect: UIVisualEffect?

    // MARK: Init

    public init(effect: UIVisualEffect? = nil) {
        self.effect = effect
    }

    // MARK: Public API

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }

}

final class ProfileInfoViewController: UIViewController {

    private let profile: Profile

    init(profile: Profile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(
            rootView: ProfileInfoView(
                profile: profile,
                dismissAction: { [weak self] in
                    self?.dismiss(animated: true)
                }
            )
        )

        let rootView = hostingController.view as UIView
        rootView.backgroundColor = .clear
        rootView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootView)

        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rootView.leftAnchor.constraint(equalTo: view.leftAnchor),
            rootView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

}
