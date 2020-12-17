//
//  numberWindowStateArrayObject.swift
//  castleGame
//  Created by Alfredo Rebolloso
//

import Foundation

class numberWindowStateArrayObject: Codable {
    
    //MARK: - Propoerties
    var array: [numberWindowStateObject]?

    init(){}
    
    init(array: [numberWindowStateObject]){
        self.array = array
    }
}
