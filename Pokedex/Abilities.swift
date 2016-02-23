//
//  Abilities.swift
//  Pokedex
//
//  Created by Robin Somlette on 22-02-2016.
//  Copyright © 2016 Robin Somlette. All rights reserved.
//

import Foundation

class Ability {
    private var _level: Int!
    private var _name: String!
    
    private var _accuracy: String!
    private var _pp: String!
    private var _description: String!
    private var _attack: String!

    var name: String {
        return _name
    }
    
    var level: Int {
        return _level
    }
    
    var accuracy: String {
        return _accuracy
    }
    
    var pp: String {
        return _pp
    }
    
    var description: String {
        return _description
    }
    
    var attack: String {
        return _attack
    }
    
    init(level: Int, name: String, accuracy: String, pp: String, description: String, attack: String) {
        self._level = level
        self._name = name
        
        self._accuracy = accuracy
        self._description = description
        self._pp = pp
        self._attack = attack
    }


}