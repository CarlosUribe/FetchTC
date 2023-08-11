//
//  CommonDessertCell.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit

class CommonDessertCell: UICollectionViewCell {
    static let identifier = "CommonDessertCell"
    var data: Meal? {
        didSet {
            configCell()
        }
    }

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 16, weight: .regular, width: .expanded)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [nameLabel, image].forEach(self.addSubview)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            image.widthAnchor.constraint(equalToConstant: 50),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 15),
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func configCell() {
        self.nameLabel.text = data?.strMeal
        guard let url = URL(string: data?.strMealThumb ?? "") else { return }
        self.image.loadImage(at: url)
    }
}
