//
//  UserInfo.swift
//  SwiftyCompanion
//
//  Created by Anele Elphas NOROITA on 2019/11/27.
//  Copyright © 2019 Anele Elphas NOROITA. All rights reserved.
//

struct Project: Codable {
    let id : Int?
    let name : String?
    let parent_id : Int?
    let slug : String?
}

struct ProjectsUser: Codable {
    
    let final_mark: Int?
    let status: String?
    let validated: Bool?
    let project : Project?
    
    enum CodingKeys: String, CodingKey {
        case final_mark
        case status
        case validated = "validated?"
        case project
    }
}

struct Skills: Decodable {
    let name : String
    let level : Float
}

struct Cursus: Decodable {
    let grade: String?
    let level: Float?
    let skills: [Skills]?
}

struct User: Decodable {
    var login: String?
    var image_url: String?
    var first_name: String?
    var last_name: String?
    
    var phone: String?
    var email: String?
    var wallet: Int?
    var correction_point: Int?
    var locations: String?
    
    var cursus_users: [Cursus]?
    var projects_users: [ProjectsUser]?
}
