//
//  DetailModel.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit

final class DetailModel {
    private var source = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    init(_ mealID: String) {
        self.source += mealID
    }

    func getDataForDetailScreen(completion: @escaping(Result<MealDetail, BackendError>) -> Void) {
        makeAPICall { response in
            switch response {
            case .success(let dessertdetailModel):
                guard let meal = dessertdetailModel.meals.first else {
                    completion(.failure(.EmptyDetailForMeal))
                    return
                }
                
                completion(.success(meal))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func makeAPICall(completion: @escaping(Result<DessertDetailModel, BackendError>) -> Void) {
        guard let url = URL(string: source) else {
            completion(.failure(.URLError))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let model = try? jsonDecoder.decode(DessertDetailModel.self, from: data)
                if let dessertmodel = model {
                    completion(.success(dessertmodel))
                } else {
                    completion(.failure(.DataError))
                }
            } else {
                completion(.failure(.DataError))
            }

        }.resume()
    }


}

