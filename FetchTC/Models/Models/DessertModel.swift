//
//  DessertModel.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import Foundation

/*
 {"strMeal":"Apam balik","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/adxcbq1619787919.jpg","idMeal":"53049"}
 */
struct DessertModel: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Comparable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String

    static func < (lhs: Meal, rhs: Meal) -> Bool {
        lhs.strMeal < rhs.strMeal
    }
}
