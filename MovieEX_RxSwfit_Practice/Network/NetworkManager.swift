//
//  NetworkManager.swift
//  MovieEX_RxSwfit_Practice
//
//  Created by YJ on 8/8/24.
//

import Foundation
import RxSwift
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callBoxOffice(date: String) -> Single<MovieModel> {
        let url = MovieURL.url + "key=\(APIKey.key)&targetDt=\(date)"
        
        return Single.create { observer -> Disposable in
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: MovieModel.self) { response in
                    
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
