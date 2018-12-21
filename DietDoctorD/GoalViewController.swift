//
//  GoalViewController.swift
//  DietDoctorC
//
//  Created by MURRO, JOHN REXES  on 05/12/2018.
//  Copyright © 2018 MURRO, JOHN REXES . All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GoalViewController: UIViewController {
    
    @IBOutlet weak var myWeightGoal: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func returnToPreviousView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var currentWeight: String!
        var startDatetime: String!
        let delCharSet = NSCharacterSet.init(charactersIn: ", ")
        
        do{
            let result = try context.fetch(request)
            let firstItem: User = result.first as! User
            currentWeight = firstItem.currentWeight!
            startDatetime = firstItem.startDatetime!
            
            let numberFormatter = NumberFormatter()
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale.current
            
            try context.delete(firstItem)
            let newGoal = NSManagedObject(entity: entity!, insertInto: context)
            
            newGoal.setValue(myWeightGoal.text?.replacingOccurrences(of: ",", with: ""), forKey: "weightGoal")
            newGoal.setValue(currentWeight.replacingOccurrences(of: ",", with: ""), forKey: "currentWeight")
            newGoal.setValue(startDatetime, forKey: "startDatetime")
            if(Double(currentWeight)!>=Double(myWeightGoal.text!)!){
                newGoal.setValue("loss", forKey: "gainOrLoss")
            }else{
                newGoal.setValue("gain", forKey: "gainOrLoss")
            }
            request.returnsObjectsAsFaults = false
            try context.save()
        }catch{
            print("Failed")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

