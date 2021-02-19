//
//  API.swift
//  Covid19
//
//  Created by Kleyson on 16/02/2021.
//  Copyright © 2021 Kleyson Tavares. All rights reserved.
//

import Foundation
import UIKit
final class API {
    
    static func fetchCases(completion: @escaping([Case]) -> Void, completionError: @escaping(String) -> Void) {
        guard let url  =  URL(string: Endpoints.cases) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let cases = try JSONDecoder().decode([Case].self, from: data)
                    DispatchQueue.main.async {
                        completion(cases)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionError("não foi possível carregar os dados")
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completionError("Erro de conexão")
                }
            }
        }
        task.resume()
    }
}
