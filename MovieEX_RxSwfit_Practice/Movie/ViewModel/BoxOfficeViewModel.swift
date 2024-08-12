//
//  BoxOfficeViewModel.swift
//  MovieEX_RxSwfit_Practice
//
//  Created by YJ on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel: BaseViewModel {
    private var recentList: [String] = []
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let recentText: PublishSubject<String>
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let movieList: Observable<[DailyBoxOfficeList]>
        let recentList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        let recentList = BehaviorSubject(value: recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240807
                }
                
                return intText
            }
            .map { return "\($0)"}
            .flatMap { value in
                NetworkManager.shared.callBoxOffice(date: value)
                    .catch { error in
                        return Single<MovieModel>.never()
                    }
            }
            .subscribe(with: self) { owner, movie in
                boxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print("error: \(error)")
            } onCompleted: { owner in
                print("completed")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)

        input.searchText
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        return Output(movieList: boxOfficeList,
                      recentList: recentList)
    }
}
