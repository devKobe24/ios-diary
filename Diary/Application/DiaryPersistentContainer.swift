//
//  DiaryPersistentContainer.swift
//  Diary
//
//  Created by 조호준 on 2023/09/05.
//

import CoreData

final class DiaryPersistentContainer: NSPersistentContainer {
    func saveContext() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func createItem(_ item: Diary) {
        let newItem = DiaryEntity(context: viewContext)
        newItem.id = item.id
        newItem.title = item.title
        newItem.body = item.body
        newItem.createdAt = item.createdAt
        
        saveContext()
    }
    
    func getAllItems() -> [Diary] {
        do {
            let entities = try viewContext.fetch(DiaryEntity.fetchRequest())
            var diaryList: [Diary] = []
            
            entities.forEach {
                guard let id = $0.id,
                      let title = $0.title,
                      let body = $0.body,
                      let createdAt = $0.createdAt else {
                    return
                }
                
                let diary = Diary(id: id, title: title, body: body, createdAt: createdAt)
                diaryList.append(diary)
            }
            
            return diaryList
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
