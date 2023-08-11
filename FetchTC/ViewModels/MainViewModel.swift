//
//  MainViewModel.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit
import Combine

class MainViewModel {
    let mainModel = MainModel()
    @Published var model: [Meal]?

    var cancellable = Set<AnyCancellable>()

    func serviceCall() {
        self.mainModel.getDataForMainScreen(completion: { [weak self] response in
            switch response {
            case .success(let model):
                self?.model = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
