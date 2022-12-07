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
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Button {
                    dismissAction()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .padding()


            Image(profile.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .cornerRadius(10)

            Text(profile.name)
                .font(.title)

            Text(profile.description)
                .font(.headline)

            Spacer()
        }
        .background(Material.ultraThinMaterial)
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
            rootView: ProfileInfoView(profile: profile, dismissAction: {
                self.dismiss(animated: true)
            })
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
