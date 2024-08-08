//
//  MovieModel.swift
//  MovieEX_RxSwfit_Practice
//
//  Created by YJ on 8/8/24.
//

import Foundation

struct MovieModel {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
    let openDt: String
}
