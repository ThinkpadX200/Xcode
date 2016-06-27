//
//  Meal.swift
//  FoodTracker
//
//  Created by Richard on 6/9/16.
//  Copyright © 2016 Richard. All rights reserved.
//

import UIKit

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    //Creating a persistant file path to the data
    
    //Static means the constants apply to the class as a whole
    //Outside of the class, we can refer to the constants with "Meal.ArchiveURL.path!"
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    
    //MARK: Types
    
    struct PropertyKey {
        
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
        
    }
    
    
    //MARK: Intialization
    init?(name: String, photo: UIImage?, rating: Int) {
        
        //Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        //Initializationg should fail if there is no name or if the rating is negative
        if name.isEmpty || rating < 0 {
            return nil
        }
        
    }
    
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        //Encodes the value of each property on the Meal class and stores them in a corresponding key
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    //required* means that the init must be implemented in every subclass
    //convenience initializers are secondary, in this case, the init is only called when there's saved data to be loaded
    required convenience init?(coder aDecoder: NSCoder) {
        
        //decodeObjectForKey unarchives stored info about object as type AnyObject, then gets force downcasted to String
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        //Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        //decodeTinegerForKey unarchives an integer, which doesn't need to be downcast
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        //Must call designated Initializer
        //Convenience inits are required to call one of it's class's designated initializers before completing
        self.init(name: name, photo: photo, rating: rating)
        
        
        
        
    }


}















