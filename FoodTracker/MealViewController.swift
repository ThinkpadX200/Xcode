//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Richard on 6/3/16.
//  Copyright © 2016 Richard. All rights reserved.
//

import UIKit

class MealViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
        This value is either passed by 'MealTableViewController' in
            'prepareForSegue(_:sender:)'
        or constructed as part of adding a new meal
    */
    var meal: Meal?

    // Place to do setup work for data population when a view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle the text field's user input through delegate callbacks
        nameTextField.delegate = self // self refers to the ViewController class, we're defining nameTextField as a delegate
        
        //Set up views id editing an existing meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Diable the Save button when editing.
        //saveButton.enabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        //Moved the dismissViewController call to this if statement, so it's only called when isPresentingInAddMealMode is true
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        //gets called when meal scene was pushed onto the navigation stack on top of the meal list scene
        else {
            navigationController!.popViewControllerAnimated(true)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            // The ?? operator is use to return the value of an optional if the optional has a value, and return "" if it's value is nil
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // Set the meal to be passed to MealTableViewController after the unwind segue
            meal = Meal(name: name, photo: photo, rating: rating)
        }
        
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
}