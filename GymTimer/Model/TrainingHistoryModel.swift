//
//  TrainingHistoryModel.swift
//  GymTimer
//
//  Created by 陳逸煌 on 2023/6/30.
//

import Foundation

class TrainingHistoryModel: Codable {
    
    var trainingModels: [TrainingModel] = []
    
    internal init(trainingModels: [TrainingModel] = []) {
        self.trainingModels = trainingModels
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.trainingModels, forKey: .trainingModels)
    }
    enum CodingKeys: CodingKey {
        case trainingModels
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.trainingModels = try container.decode([TrainingModel].self, forKey: .trainingModels)
    }
}

class TrainingModel: Codable {
    internal init(text: String? = nil, time: String? = nil) {
        self.text = text
        self.time = time
    }
    
    enum CodingKeys: CodingKey {
        case text
        case time
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.text, forKey: .text)
        try container.encodeIfPresent(self.time, forKey: .time)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.time = try container.decodeIfPresent(String.self, forKey: .time)
    }
    var text: String?
    var time: String?
}
