//
//  Pokemon.swift
//  Pokedex
//
//  Created by Robin Somlette on 21-02-2016.
//  Copyright © 2016 Robin Somlette. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    private var _moves = [Ability]()
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var moves: [Ability] {
        if _moves.isEmpty {
            _moves = []
        }
        return _moves.sort({ $0.level < $1.level })
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(pokedexID)"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: self._pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
//                 print(types.debugDescription)
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += " / \(name.capitalizedString)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                print(self._type)
                
                if let descriptionArr = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArr.count > 0 {
                    
                    if let url = descriptionArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { (response) -> Void in
                            
                            let descriptionResult = response.result
                            
                            if let descDict = descriptionResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            completed()
                        }
                        
                        
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        //remove mega evolution
                        if to.rangeOfString("mega") == nil {
                            //get uri
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon", withString: "")
                                let pokeNum = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionID = pokeNum
                                self._nextEvolutionName = to
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                }
                            }
                        }
                    }
                }
                
                if let abilities = dict["moves"] as? [Dictionary<String, AnyObject>] where abilities.count > 0 {
                    for ability in abilities {
                        if ability["learn_type"] as? String == "level up" {
                            if let level = ability["level"] as? Int, let name = ability["name"] as? String, let url = ability["resource_uri"] as? String {
                                
                                let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                                
                                Alamofire.request(.GET, nsurl).responseJSON { (response) -> Void in
                                    
                                    let moveResult = response.result
                                    
                                    if let movesDict = moveResult.value as? Dictionary<String, AnyObject> {
                                        
                                        if let accuracy = movesDict["accuracy"] as? Int, let pp = movesDict["pp"] as? Int, let description = movesDict["description"] as? String, let attack = movesDict["power"] as? Int {
                                            self._moves.append(Ability(level: level, name: name, accuracy: "\(accuracy)", pp: "\(pp)", description: description, attack: "\(attack)"))
//                                            print(self._moves)
                                        }
                                    }
                                    completed()
                                }
                                
                                
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
}