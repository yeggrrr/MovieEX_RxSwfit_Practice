//
//  BoxOfficeViewController.swift
//  MovieEX_RxSwfit_Practice
//
//  Created by YJ on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BoxOfficeViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout())
    private let tableView = UITableView()
    
    private let viewModel = BoxOfficeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func bind() {
        let recentText = PublishSubject<String>()
        
        let input = BoxOfficeViewModel.Input(recentText: recentText,
                                             searchButtonTap: searchBar.rx.searchButtonClicked,
                                             searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = element

            }
            .disposed(by: disposeBag)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element.movieNm
                cell.downloadButton.setTitle(element.openDt, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubviews([searchBar, collectionView, tableView])
        
        // searchBar
        navigationItem.titleView = searchBar
        
        // collectionView
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGray6
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        // tableView
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.backgroundColor = .systemGray4
        tableView.rowHeight = 100
        tableView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    private static func collectionViewlayout() ->  UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}

