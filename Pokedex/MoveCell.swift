//
//  MoveCell.swift
//  Pokedex
//
//  Created by Robin Somlette on 22-02-2016.
//  Copyright © 2016 Robin Somlette. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {

    @IBOutlet weak var abilityName: UILabel!
    @IBOutlet weak var abilityLevel: UILabel!
    
    @IBOutlet weak var abilityDescription: UILabel!
    @IBOutlet weak var abilityAttack: UILabel!
    @IBOutlet weak var abilityAccuracy: UILabel!
    @IBOutlet weak var abilityPP: UILabel!
    
    var ability: Ability!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//    }

    func configureCell(ability: Ability) {
        self.ability = ability
        self.abilityName.text = ability.name
        self.abilityLevel.text = "Level: \(ability.level)"
        self.abilityAccuracy.text = ability.accuracy
        self.abilityDescription.text = ability.description
        self.abilityPP.text = ability.pp
        self.abilityAttack.text = ability.attack
    }
}
