//
//  NetworkManager.swift
//  MovieEX_RxSwfit_Practice
//
//  Created by YJ on 8/8/24.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func callBoxOffice(date: String) -> Observable<MovieModel> {
        let url = MovieURL.url + "key=\(APIKey.key)&targetDt=\(date)"
        
        let result = Observable<MovieModel>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let movieData = try? JSONDecoder().decode(MovieModel.self, from: data) {
                    observer.onNext(movieData)
                    observer.onCompleted()
                } else {
                    print("Failed Decoding")
                    observer.onError(APIError.unknownResponse)
                }
            }
            .resume()
            
            return Disposables.create()
        }
        
        return result
    }
}
