//
//  DetailView.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit
import Combine

class DetailView: UIViewController {
    let mealModel: Meal
    var detailModel: MealDetail?
    let detailViewModel = DetailViewModel()

    var cancellable = Set<AnyCancellable>()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 22, weight: .medium, width: .expanded)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    lazy var instructionsTextView: UITextView = {
        let instructionsTextView = UITextView()
        instructionsTextView.textColor = .black
        instructionsTextView.backgroundColor = .clear
        instructionsTextView.font = .systemFont(ofSize: 13, weight: .regular, width: .expanded)
        instructionsTextView.textAlignment = .justified
        instructionsTextView.isEditable = false
        instructionsTextView.isSelectable = false
        instructionsTextView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        instructionsTextView.translatesAutoresizingMaskIntoConstraints = false
        return instructionsTextView
    }()

    lazy var ingredientsTextView: UITextView = {
        let ingredientsTextView = UITextView()
        ingredientsTextView.textColor = .black
        ingredientsTextView.backgroundColor = .clear
        ingredientsTextView.font = .systemFont(ofSize: 13, weight: .regular, width: .expanded)
        ingredientsTextView.textAlignment = .justified
        ingredientsTextView.isEditable = false
        ingredientsTextView.isSelectable = false
        ingredientsTextView.translatesAutoresizingMaskIntoConstraints = false
        return ingredientsTextView
    }()

    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    init(_ model: Meal) {
        self.mealModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        setupBindings()
        requestDetailForMeal(mealModel.idMeal)
    }

    private func setupViews(){
        [stackView].forEach(view.addSubview)
        [titleLabel, image, instructionsTextView, ingredientsTextView].forEach(stackView.addArrangedSubview)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupBindings() {
        detailViewModel.$model.sink { [weak self] model in
            self?.detailModel = model
            DispatchQueue.main.async {
                self?.configView()
            }

        }.store(in: &cancellable)
    }

    private func configView() {
        titleLabel.text = mealModel.strMeal
        guard let instructions = detailModel?[MealDetailSelection.Instructions.rawValue],
              let thumbnailURL = detailModel?[MealDetailSelection.Thumbnail.rawValue],
              let url = URL(string: thumbnailURL ?? "") else { return }

        instructionsTextView.text = instructions
        ingredientsTextView.text = getIngredientsLine()

        image.loadImage(at: url)
    }

    private func requestDetailForMeal(_ mealId: String) {
        detailViewModel.serviceCall(with: mealId)
    }

    private func getIngredientsLine() -> String {
        var line = "Ingredients:\n"
        guard let detail = detailModel else { return "" }

        for index in 1...20 {
            let keyIngredient = MealDetailSelection.Ingredient.rawValue + "\(index)"
            let keyMeasure = MealDetailSelection.Measure.rawValue + "\(index)"

            if let ingredient = detail[keyIngredient] {
                if ingredient != " " {
                    line += "\n" + (ingredient ?? "")
                }
            }

            if let measure = detail[keyMeasure] {
                if measure != " " {
                    line += " - " + (measure ?? "") + "\n"
                }
            }
        }

        return line
    }

    
}
