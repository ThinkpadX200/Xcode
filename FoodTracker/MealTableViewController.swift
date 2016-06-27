//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Richard on 6/9/16.
//  Copyright © 2016 Richard. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem()
        
        //If loadMeals() returns an array of meal objects, the if execution adds any meals that were successfully loaded into the meals array
        //If loadMeals() returns nil (no meals in array), then the if execution doesn't occur
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }
        else {
            //Load the sample Data
            loadSampleMeals()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "meal3")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        meals += [meal1, meal2, meal3]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //tells the table view how many sections to display
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // changed from 0 to 1, to make sure that the table view shows 1 section instead of 0
        return 1
    }

    //provides the rows for each section of the table view, we want to provide a row for every meal
    //the number of rows should be the number of meal objects in the meals array
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // to figure out the number of rows in the meals array, we use the array property: .count
        return meals.count
    }

    //this method configures and provides a cell to display in each given row
    //each row has one cell, and the cell determines the content in the row and how it's laid out
    //cellForRowAtIndexPath only asks for the cells for the rows that are currently being displayed
    
    //this method works by fetching the "meal" in the meals array and setting the cells properties to the corresponding values from the meal class
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier constant called "cellIdentifier"
        let cellIdentifier = "MealTableViewCell"
        
        //used as! to downcast the type of the cell to the custom cell class subclass MealTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        //Fetches the appropriate meal for the data source layout
        let meal = meals[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        //1. Tries to downcast sourceViewController of the segue from type UIViewController --> MealViewController
        //2. If let checks to see if downcast was succesful (value) or not successful (nil)
        //3. If let also checks to see if meal property on sourceViewController is nil
        //4. If both are successful, the view controller is assigned to local constant sourceViewController, and the meal property of sourceViewController is assigned to the local constant meal, and executes the if statement
        
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            
            // Checks whether a row in the table is selected, executes if statement if a meal is selected
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                //update an existing meal
                
                //updates appropriate entry in meals
                //reloads appropriate row in table to view updated data
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                
                // Add a new meal
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // Save the Meals whenever a new one is added or an existing one is updated
            saveMeals()
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            // Saves meals array when a meal is deleted
            // Removes Meal object from meals
            meals.removeAtIndex(indexPath.row)
            saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
            
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // Use method to identify which segue is occuring and to display the appropriate info in meal scene
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            
            // Force downcasting. mealDetailViewController gets assigned the value of segue.destinationViewController as type MealViewController
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // if downcast is successful, selectedMealCell gets assigned sender as type MealTableViewCell and if statement executes
            // if downcast fails (nil), if statement is not executed
            if let selectedMealCell = sender as? MealTableViewCell {
                
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
                
            }
            
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
            
        }
        
        
    }
    
    // MARK: NSCoding
    
    func saveMeals() {
        
        //attempts to archive the meals to a specific location, and returns true if successful
        //uses Meal.ArchiveURL to find data path to save information
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save meals....")
        }
    }
    
    //has an optional return type of an array of Meal objects, or nil
    func loadMeals() -> [Meal]? {
        
        //attempts to unarchive object stored at Meal.ArchiveURL.path and downcast as object to an array of Meal objects
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
        
    }
    


}











