//
//  RecentQuestionsViewModel.swift
//  HCA_Interview_ Assignment
//
//  Created by Bharath Nallatheegala on 12/6/20.
//

import Foundation

class RecentQuestionsViewModel {
    
    init() { }
    
    func filter(with responce: QuestionsModel) -> [Item]? {
        guard let items = responce.items else {
            return nil
        }
            let filteredData = items.filter { (item) -> Bool in
                return item.isAnswered ?? false && item.answerCount ?? 0 > 1 ? true : false
            }
        return filteredData.isEmpty ? nil : filteredData
        }

}

