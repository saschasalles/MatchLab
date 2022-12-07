//
//  Person.swift
//  MatchLab
//
//  Created by Sascha Sallès on 07/12/2022.
//

import Foundation

final class Profile {

    private(set) static var all: [Profile] = [
        Profile(
            name: "Taylor Swift",
            description: "Hello I'm Taylor I love Coffee, Swift and Apple. I'm 32 and I don't have a boyfriend. Why don't we hang out one day ?",
            imageName: "taylor"),
        Profile(
            name: "Craig Federighi",
            description: "Boggoss at Apple, Futur PDG mais chut dites R à Tim",
            imageName: "craig"
        ),
        Profile(
            name: "Gatien Didry",
            description: "Je serai vous offrir une, non deux, bon d'accord trois bière. On se la colle ?",
            imageName: "gatien"),
        Profile(
            name: "Elon Musk",
            description: "Entrepreneur à succès, Serial Killer at Twitter",
            imageName: "elon"
        ),
        Profile(
            name: "Thomas Le Naour",
            description: "Je m'appelle Thomas Le Naour et je suis développeur spécialisé dans la création de sites web sur-mesure",
            imageName: "tln"
        )
    ]

    init(
        name: String,
        description: String,
        imageName: String
    ) {
        self.name = name
        self.description = description
        self.imageName = imageName
    }

    let name: String
    let imageName: String
    let description: String

    private(set) var wasMatched: Bool = false

    func setMatched(_ matched: Bool) {
        self.wasMatched = matched
    }
}
