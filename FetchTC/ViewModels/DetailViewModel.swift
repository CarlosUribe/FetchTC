//
//  DetailViewModel.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit
import Combine

class DetailViewModel {
    @Published var model: MealDetail?

    var cancellable = Set<AnyCancellable>()

    func serviceCall(with mealId: String) {
        let detailModel = DetailModel(mealId)
        detailModel.getDataForDetailScreen(completion: { [weak self] response in
            switch response {
            case .success(let model):
                self?.model = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
