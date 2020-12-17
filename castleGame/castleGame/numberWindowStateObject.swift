//
//  numberWindowStateObject.swift
//  castleGame
//  Created by Alfredo Rebolloso
//

import UIKit

class numberWindowStateObject: Codable {
    
    //MARK: - Propoerties
    var name: String?
    var num: Int?

    init(){}
    
    init(name: String, num: Int){
        self.name = name
        self.num = num
    }
}
