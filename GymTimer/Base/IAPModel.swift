//
//  IAPModel.swift
//  AnnaDJ
//
//  Created by yihuang on 2023/3/22.
//

import Foundation

class SoundModel: JsonModel {
    required init(json: JBJson) {
        self.title = json["title"].stringValue
        self.number = json["number"].intValue
        self.id = json["id"].stringValue
    }
    var title: String = ""
    var id: String = ""
    var number: Int = 0
}

class IAPModel: JsonModel {
    
    var canBuyType: [SoundModel] = []
    
    required init(json: JBJson) {
        self.canBuyType = json["canBuyType"].arrayValue.map({SoundModel(json: $0)}).filter({$0.id != ""})
    }

}

