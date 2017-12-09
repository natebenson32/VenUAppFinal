//
//  user.swift
//  VenU App
//
//  Created by X Code User on 12/4/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import Foundation

struct User{
    var email:String?
    var password:String?
    
    init(email:String?, password:String?){
        self.email = email
        self.password = password
    }
}
