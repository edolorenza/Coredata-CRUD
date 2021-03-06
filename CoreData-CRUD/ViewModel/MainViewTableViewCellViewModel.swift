//
//  MainViewTableViewCellViewModel.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit

struct MainViewTableViewCellViewModel {
    let avengers: Avengers
    
    init(avengers: Avengers) {
        self.avengers = avengers
    }
    
    var image: UIImage? {
        if let imageData = avengers.image {
            return UIImage(data: imageData as Data)
        }
        return UIImage(named: "photo")
    }
    
    
    var name: String {
        guard let firstName = avengers.firstName else { return "" }
        guard let lastName = avengers.lastName else { return ""}
        return firstName +  " \(lastName)"
    }
    
    var firstName: String? {
        return avengers.firstName
    }
    
    var lastName: String? {
        return avengers.lastName
    }
    
    var date: String? {
        return avengers.birthDate
    }
    
    var email: String? {
        return avengers.email
    }
    
    var id: Int32 {
        return avengers.id
    }
}
