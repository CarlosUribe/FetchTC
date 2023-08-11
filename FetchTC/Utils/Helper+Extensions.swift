//
//  Helper+Extensions.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit

enum BackendError: Error {
    case URLError
    case DataError
    case EmptyDetailForMeal
}

enum MealDetailSelection: String {
    case Instructions = "strInstructions"
    case Ingredient = "strIngredient"
    case Measure = "strMeasure"
    case Thumbnail = "strMealThumb"
}

typealias MealDetail = [String: String?]

extension UIImageView {
    func loadImage(at url: URL) {
        UIImageLoader.loader.load(url, for: self)
    }

    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
