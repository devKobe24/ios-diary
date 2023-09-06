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
    
    private var container: NSPersistentContainer?
    private let appDelegate = {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        return appDelegate
    }()
    
    private init() {}
    
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
