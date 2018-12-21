//
//  GlobalTimer.swift
//  DietDoctorD
//
//  Created by June Hermoso on 17/12/2018.
//  Copyright © 2018 JH Company. All rights reserved.
//

import UIKit
import CoreData

class GlobalTimer: NSObject {
    static let sharedTimer: GlobalTimer = GlobalTimer()
    
    var delegate: GlobalTimerDelegate?
    var internalTimer: Timer?
    var globalTime: Date?
    var dateFormatter: DateFormatter = DateFormatter()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    var startingTime: String!
    
    func startTimer(){
        context = appDelegate.persistentContainer.viewContext
        self.internalTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
        self.getStartingTime()
    }
    
    @objc
    func fireTimerAction(){
        DispatchQueue.global(qos: .default).async {
            self.updateGlobalTime()
        }
    }
    
    func updateGlobalTime(){
        delegate?.didUpdateGlobalTimer(_sender: self, message: startingTime)
    }
    
    @objc
    func getStartingTime(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        request.returnsObjectsAsFaults = false
        do{
            var result = try context.fetch(request)
            if(result.count>0){
                let firstItem: User = result.first as! User
                startingTime = firstItem.startDatetime as! String
            }else{
                startingTime = dateFormatter.string(from: Date())
            }
        }catch{
            debugPrint("ERROR FETCHING REQUEST")
        }
    }
    
    func setStartingTime(dateTime: String){
        startingTime = dateTime
    }
    
    func globalStartTime() -> String{
        return startingTime
    }
}
