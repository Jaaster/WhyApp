//
//  CoreDataLists.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/8/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import CoreData
struct CoreDataLists {
    
    let context = CDPersistenceService.context
    
    func goals() -> [Goal] {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        do {
            let data = try context.fetch(request)
            return data
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
