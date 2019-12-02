//
//  ProfileViewController.swift
//  SwiftyCompanion
//
//  Created by Anele Elphas NOROITA on 2019/11/27.
//  Copyright © 2019 Anele Elphas NOROITA. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var login: String?
    var api: IntraAPI?
    var searchController: UIViewController?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var walletCountLabel: UILabel!
    @IBOutlet weak var correctionPointsCountLabel: UILabel!
    @IBOutlet weak var progressLevelView: UIProgressView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background.frame.size = UIScreen.main.bounds.size
        self.background.image = UIImage(named: "42Background")
        getAvatar()
        getContacts()
        getProgressLevel()
    }
    
    func getContacts()
    {
        let fist_name: String = (api?.user?.first_name)!
        let lasе_name: String = (api?.user?.last_name)!
        self.backgroundView.layer.cornerRadius = 15
        self.loginLabel.text = api?.user?.login
        self.fullNameLabel.text = fist_name + " " + lasе_name
        self.phoneNumberLabel.text = api?.user?.phone != nil ? "📲 " + (api?.user?.phone)! : " ";
        self.emailLabel.text = "📩 " + (api?.user?.email)!
        if let countWall: Int = api?.user?.wallet {
            self.walletCountLabel.text = String(countWall)
        }
        if let countPoint: Int = api?.user?.correction_point {
            self.correctionPointsCountLabel.text = String(countPoint)
        }
    }
    
    func getAvatar() {
        let url = URL(string: (api?.user?.image_url)!)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    self.profilePicture.layer.borderWidth = 1
                    self.profilePicture.clipsToBounds = true
                    self.profilePicture.image = UIImage(data: data)
                }
            }
        }
    }
    
    
    func getProgressLevel()
    {
        if let level: Float = api?.user?.cursus_users![0].level
        {
            self.levelLabel.text = "level \(level)%"
            self.levelLabel.layer.cornerRadius = 10
            self.levelLabel.clipsToBounds = true
            self.progressLevelView.progress = level.truncatingRemainder(dividingBy: 1)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //How many section in Tableview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    //How many rows per section, depends on the number of results returned
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tableView1 {
            return (self.api?.user?.cursus_users![0].skills?.count) ?? 0
        }
        else {
            return (self.api?.projectsArray.count)!
        }
    }
    
    //Asks the data source (API results) for a cell to insert in a particular location of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        if tableView == tableView1
        {
            if let cellSkill = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath) as? SkillsTableViewCell
            {
                if let level: Float = api?.user?.cursus_users![0].skills![indexPath.row].level
                {
                    if let name: String = api?.user?.cursus_users![0].skills![indexPath.row].name {
                        cellSkill.skillNameLabel.text = name
                    }
                    cellSkill.nbrLabel.text = String(level) + " %"
                    cellSkill.progressView.progress = level.truncatingRemainder(dividingBy: 1)
                    return cellSkill
                }
            }
        }
        if tableView == tableView2
        {
            if let cellProj = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectTableViewCell
            {
                if let name: String = api?.projectsArray[indexPath.row].project?.name
                {
                    if let finalMark: Int = api?.projectsArray[indexPath.row].final_mark, let valid: Bool = api?.projectsArray[indexPath.row].validated
                    {
                        cellProj.ProjectNameLabel.text = valid ? "✅ " + name : "❌ " + name;
                        cellProj.finalMarkLabel.text = String(finalMark) + " %"
                    }
                    else
                    {
                        cellProj.ProjectNameLabel.text = "🕓 " + name
                        cellProj.finalMarkLabel.text = " "
                    }
                    return cellProj
                }
            }
        }
        return UITableViewCell()
    }
    
    //Releases all resources
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.api?.projectsArray.removeAll()
        self.api?.user?.projects_users?.removeAll()
        self.api?.user?.cursus_users?.removeAll()
        self.api?.user = nil
    }
}
