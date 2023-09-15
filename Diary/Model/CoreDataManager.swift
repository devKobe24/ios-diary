//
//  CoreDataManager.swift
//  Diary
//
//  Created by Minseong Kang on 2023/09/06.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var diaryContentsEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "DiaryContents", in: context)
    }
    
    private let appDelegate = {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        return appDelegate
    }()
    
    private init() {}
    
    func insertDiaryContents(_ diary: Diary) {
        if let entity = diaryContentsEntity {
//            let managedObject = 
        }
    }
    
    // MARK: - READ
    func fetchDiaryContents() throws -> [DiaryContents] {
        
        guard let appDelegate = self.appDelegate else {
            throw FetchDiaryContentsError.appDelegate
        }
        
        let request = DiaryContents.fetchRequest()
        let context = appDelegate.fetchContext()
        
        guard let result = try? context.fetch(request) else {
            throw FetchDiaryContentsError.fetch
        }
        
        return result
    }
    
    func getDiaryContents() throws -> [Diary] {
        var diaryData: [Diary] = []
        
        do {
            let fetchResults = try fetchDiaryContents()
            
            for result in fetchResults {
                guard let title = result.title else {
                    throw GetDiaryContentsError.titleDataEmpty
                }
                
                guard let body = result.body else {
                    throw GetDiaryContentsError.titleDataEmpty
                }
                
                guard let createdAt = result.createdAt as? Int else {
                    throw GetDiaryContentsError.titleDataEmpty
                }
                
                diaryData.append(
                    Diary(
                        title: title,
                        body: body,
                        createdAt: createdAt
                    )
                )
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return diaryData
    }
}

enum FetchDiaryContentsError: LocalizedError {
    case appDelegate
    case fetch
}

enum GetDiaryContentsError: LocalizedError {
    case fetch
    case titleDataEmpty
    case bodyDataEmpty
    case createdAtDataEmpty
}
