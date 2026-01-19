//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.01.26.
//

import CoreData
internal import Combine

class DataController: ObservableObject {
    @Published var selectedFilter: Filter? = Filter.all

    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
         self.container = NSPersistentCloudKitContainer(name: "Main")
         
         if inMemory {
             container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
         }
         
         container.loadPersistentStores {
             storeDescription, error in
             if let error {
                 fatalError("Fatal error loading persistent stores: \(error)")
             }
         }
    }
    
    func createSampleData() {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(i)"
            
            for j in 1...10 {
                let issue = Issue(context: viewContext)
                issue.title = "Issue \(i)-\(j)"
                issue.content = "Content for issue \(i)-\(j)"
                issue.creationDate = Date.now
                issue.completion = Bool.random()
                issue.priority = Int16.random(in: 1...2)
                tag.addToIssues(issue)
            }
        }
        
        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequst: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequst
        )
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(
            batchDeleteRequest
        ) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObject] ?? []]
            NSManagedObjectContext
                .mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [container.viewContext]
                )
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request2)
        
        save()
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
}
