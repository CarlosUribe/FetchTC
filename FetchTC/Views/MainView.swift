//
//  MainView.swift
//  FetchTC
//
//  Created by Carlos Uribe on 10/08/23.
//

import UIKit
import Combine

class MainView: UIViewController {
    private let mainViewModel = MainViewModel()
    var model: [Meal]?
    var cancellable = Set<AnyCancellable>()

    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(CommonDessertCell.self, forCellWithReuseIdentifier: CommonDessertCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
        setupBindings()
        serviceCall()
    }

    private func setupViews() {
        [collectionView].forEach(self.view.addSubview)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15)
        ])
    }

    private func setupBindings() {
        mainViewModel.$model.sink { [collectionView] model in
            self.model = model?.sorted(by: { $0 < $1 })

            DispatchQueue.main.async {
                collectionView.reloadData()
            }

        }.store(in: &cancellable)
    }

    private func serviceCall() {
        mainViewModel.serviceCall()
    }

    private func getDataFromModel(_ index: IndexPath) -> Meal? {
        guard let model = model else { return nil }

        return model[index.row]
    }
}

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let meal = getDataFromModel(indexPath) else { return }

        let detail = DetailView(meal)
        self.present(detail, animated: true)
    }
}

extension MainView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else { return 0 }

        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonDessertCell.identifier, for: indexPath) as! CommonDessertCell
        cell.data = getDataFromModel(indexPath)

        return cell
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 5, height: 35)
    }
}

