//
// Created by 舘佳紀 on 2020/06/16.
// Copyright (c) 2020 Yoshiki Tachi. All rights reserved.
//

import Foundation

enum LoadStatus : String {
    case initial
    case loading
    case loadMore
    case fetching
    case full
    case error
}

class ViewModel {

    var reloadHandler: () -> Void = {  }

    var articles : [Article]  = [] {
        didSet {
            reloadHandler()
        }
    }

    private var loadStatus: String = LoadStatus.initial.rawValue
    private var page : Int = 1

    func fetchArticles() {
        guard loadStatus != LoadStatus.fetching.rawValue && loadStatus != LoadStatus.full.rawValue else { return }
        guard let url : URL = URL(string: "http://qiita.com/api/v2/items?page=\(page)&per_page=20") else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            do {
                guard let data = data else {
                    self.loadStatus = LoadStatus.error.rawValue
                    return
                }
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any] else {
                    self.loadStatus = LoadStatus.error.rawValue
                    return
                }
                let articlesJson = jsonArray.flatMap { (json: Any) -> [String: Any]? in
                    return json as? [String: Any]
                }
                let articles = articlesJson.map { (articleJson: [String: Any]) -> Article in
                    return Article(json: articleJson)
                }
                if articles.count == 0 {
                    self.loadStatus = LoadStatus.full.rawValue
                    return
                }
                DispatchQueue.main.async() { () -> Void in
                    self.articles = self.articles + articles
                    self.loadStatus = LoadStatus.loadMore.rawValue
                }
                if self.page == 100 {
                    self.loadStatus = LoadStatus.full.rawValue
                    return
                }
                self.page += 1
            }
            catch {
                print(error)
                self.loadStatus = LoadStatus.error.rawValue
            }
        })
        task.resume()
    }

}
