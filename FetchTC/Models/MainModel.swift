//
//  MainModel.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit

final class MainModel {
    private let source = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    func getDataForMainScreen(completion: @escaping(Result<[Meal], BackendError>) -> Void) {
        makeAPICall {   response in
            switch response {
            case .success(let dessertModel):
                let meal = dessertModel.meals.compactMap{ $0 }
                completion(.success(meal))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func makeAPICall(completion: @escaping(Result<DessertModel, BackendError>) -> Void) {
        guard let url = URL(string: source) else {
            completion(.failure(.URLError))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let model = try? jsonDecoder.decode(DessertModel.self, from: data)
                if let dessertModel = model {
                    completion(.success(dessertModel))
                } else {
                    completion(.failure(.DataError))
                }
            } else {
                completion(.failure(.DataError))
            }

        }.resume()
    }


}
