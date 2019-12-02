//
//  IntraAPI.swift
//  SwiftyCompanion
//
//  Created by Anele Elphas NOROITA on 2019/11/27.
//  Copyright © 2019 Anele Elphas NOROITA. All rights reserved.
//

import UIKit

struct BearerToken: Decodable {
    var access_token: String
}

class IntraAPI
{
    let myUid: String = "3495c8a6239f5e353773399867a6ac2cefc3070e44dfe331e3102aa464cc9eaf"
    let mySecret: String = "5adfe54405674e60ef15e02364256ef35cb88fcdfadc0f1b17bd5f9eda042ab9"
    
    var token: BearerToken?
    var user : User?
    var coalition: [Coalition]?
    var projectsArray = [ProjectsUser]()
    
    func getToken()
    {
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else { return }
        
        var request = URLRequest(url: url)
        let parameters = ["grant_type": "client_credentials", "client_id" : myUid, "client_secret" : mySecret]
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do
            {
                self.token = try JSONDecoder().decode(BearerToken.self, from: data)
                print("token - " + self.token!.access_token)
            }
            catch
            {
                print(error)
                print("Intra in da lag")
            }
        }.resume()
    }
    
    func coalitionRequest(completionHandler: @escaping ([Coalition]?, Error?) -> Void)
    {
        guard let login: String = self.user?.login else {
            print("Invalid login")
            return
        }
        guard let newToken = self.token else {
            print("token is not ready yet")
            return
        }
        print(login)
        guard let url = URL(string : "https://api.intra.42.fr/v2/users/" + login + "/coalitions") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("Bearer " +  newToken.access_token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do
            {
                let responseJson = try JSONDecoder().decode([Coalition].self, from: data)
                completionHandler(responseJson, nil)
            }
            catch
            {
                completionHandler(nil, error)
            }
            }.resume()
    }
    
    func getUserData(login: String, completionHandler: @escaping (User?, Error?) -> Void) -> (Bool)
    {
        guard let newToken = self.token else {
            print("token is not ready yet")
            return (false)
        }
        
        guard let url = URL(string : "https://api.intra.42.fr/v2/users/" + login) else {
            return (false)
        }

        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("Bearer " +  newToken.access_token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do
            {
                let responseJson = try JSONDecoder().decode(User.self, from: data)
                completionHandler(responseJson, nil)
                print("USER respnse")
                print(responseJson)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }.resume()
        return (true)
    }
    

    func getProjects()
    {
        if let projectArr = user?.projects_users
        {
            for key in projectArr
            {
                guard let slug = key.project?.slug else { continue }
                guard (key.project?.name) != nil else { continue }
                if (key.project?.parent_id == nil && !slug.hasPrefix("piscine-c-")) {
                    projectsArray.append(key)
                }
            }
        }
    }
    
    
}

