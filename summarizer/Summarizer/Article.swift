//
//  Article.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/21/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Article {
    var text: String = ""
    var url: String = ""
    
    // not proper JSON format, but works for my purposes
    static func articleToJSON(a: Article) -> String {
        return "{ text: " + a.text + ", url: " + a.url + " }"
    }
    
    static func articlesToJSON(articles: [Article]) -> String {
        let encoded: [String] = articles.map({ return Article.articleToJSON($0) })
        return encoded.joinWithSeparator(", ")
    }
    
    static func articleFromJSON(s: String) -> Article {
        print(JSON(s))
        return Article()
    }
    
    static func articlesFromJSON(s: String) -> [Article] {
        let articles = s.componentsSeparatedByString("}, {")
        print(articles)
        return [Article]()
    }
}

