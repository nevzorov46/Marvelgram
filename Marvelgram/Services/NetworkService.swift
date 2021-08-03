//
//  NetworkService.swift
//  Marvelgram
//
//  Created by Иван Карамазов on 02.08.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    let stringURL = "https://static.upstarts.work/tests/marvelgram/klsZdDg50j2.json"
    
    func getMarvelHeroInfo(completionHandler: (([MarvelInfo]?) -> Void)?) {
        httpGet(stringURL, completionHandler: completionHandler)
    }
    
    private func httpGet<T: Decodable>(_ url:String, completionHandler : ((T?) -> Void)?)  {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self]
            (data, response, error) in
            guard let this = self else { return }
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            //print(String(decoding: data, as: UTF8.self))
            
            let gettingData: T? = this.parseJSON(data: data)
            
            completionHandler?(gettingData)

        })
        task.resume()
    }
    
    private func parseJSON<T: Decodable>(data: Data) -> T? {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let type = T.self
         do {
             return try decoder.decode(type, from: data)
         } catch let error as NSError {
             print(String(describing: error))
         }
         
         return nil
     }
    
    
    
    private init() {}
}
