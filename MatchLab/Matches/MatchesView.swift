//
//  MatchesView.swift
//  MatchLab
//
//  Created by Sascha Sallès on 07/12/2022.
//

import SwiftUI

struct MatchesView: View {
    var body: some View {
        List {
            HStack(spacing: 10) {
                Image("taylor")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .cornerRadius(8)
                Text("Taylor Swift")
            }
        }
    }
}
