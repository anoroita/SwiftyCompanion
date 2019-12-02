//
//  SearchViewController.swift
//  SwiftyCompanion
//
//  Created by Anele Elphas NOROITA on 2019/11/27.
//  Copyright © 2019 Anele Elphas NOROITA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Background: UIImageView!
    @IBOutlet weak var loginText: UITextField!
    var token: String?
    
    let api = IntraAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Background.image = UIImage(named: "42Background")
        api.getToken()
    }
    
    @IBAction func searchUserAction(_ sender: UIButton) {
            let _ = api.getUserData(login: loginText.text!, completionHandler: { user, error in
                DispatchQueue.main.async {
                    if let userData = user {
                        if userData.login != nil {
                            self.getUserInfo(userData)
                            self.api.coalitionRequest() { coalition, error in
                                DispatchQueue.main.async {
                                    if let userCoalition = coalition {
                                        self.api.coalition = userCoalition
                                        print(self.api.coalition!)
                                        self.api.getProjects()
                                        self.performSegue(withIdentifier: "searchSegue", sender: self)
                                    }
                                }
                            }
                        }
                        else    {
                            self.showAlert(error: "Sorry...", message: "Invalid login")
                        }
                    }
                    if self.api.user == nil || (self.api.user?.cursus_users?.isEmpty)!
                    {
                        self.showAlert(error: "Error...", message: "Invalid login\n Perhaps you tried to use the user ID instead login")
                    }
                }
            })
    }
    
    
    private func getUserInfo(_ userData: User) {
        if userData.login == (self.loginText.text!.lowercased()) {
            self.api.user = userData
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue", api.user != nil
        {
            if let destination = segue.destination as? ProfileViewController
            {
                destination.login = self.loginText.text!
                destination.api = self.api
            }
        }
    }
    
    func showAlert(error: String, message: String) {
        let alertController = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default , handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


