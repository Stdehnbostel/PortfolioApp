//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.01.26.
//

import CoreData
import Combine

enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modifcationDate"
}

enum Status {
    case all, open, closed
}

class DataController: ObservableObject {
    @Published var selectedFilter: Filter? = Filter.all
    @Published var selectedIssue: Issue?

    @Published var filterText = ""
    @Published var filterTokens: [Tag] = []

    @Published var filterEnabled = false
    @Published var filterPriority = -1
    @Published var filterStatus = Status.all
    @Published var sortType = SortType.dateCreated
    @Published var sortNewestFirst = true

    private var saveTask: Task<Void, Error>?

    let container: NSPersistentCloudKitContainer

    var suggestedFilterTokens: [Tag] {
        guard filterText.starts(with: "#") else {
            return []
        }

        let trimmedFilterText = String(filterText.dropFirst().trimmingCharacters(in: .whitespaces))

        let request = Tag.fetchRequest()

        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS(c) %@", trimmedFilterText)
        }

        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }

    init(inMemory: Bool = false) {
        self.container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged
        )

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading persistent stores: \(error)")
            }
        }
    }

    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }

    func createSampleData() {
        let viewContext = container.viewContext

        for tagCounter in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(tagCounter)"

            for issueCounter in 1...10 {
                let issue = Issue(context: viewContext)
                issue.title = "Issue \(tagCounter)-\(issueCounter)"
                issue.content = "Content for issue \(tagCounter)-\(issueCounter)"
                issue.creationDate = Date.now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 1...2)
                tag.addToIssues(issue)
            }
        }
        try? viewContext.save()
    }

    func save() {
        saveTask?.cancel()
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func queueSave() {
        saveTask?.cancel()

        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
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

    func missingTags(from issue: Issue) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []

        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(Set(issue.issueTag))

        return difference.sorted()
    }

    func issuesForSelectedFilter() -> [Issue] {
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()

        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        } else {
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }

        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)

        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(
                format: "title CONTAINS[c] %@",
                trimmedFilterText
            )
            let contentPredicate = NSPredicate(
                format: "content CONTAINS[c] %@",
                trimmedFilterText
            )
            let combinedPredicate = NSCompoundPredicate(
                orPredicateWithSubpredicates: [titlePredicate, contentPredicate]
            )
            predicates.append(combinedPredicate)
        }

        if filterTokens.isEmpty == false {
            let tokenPredicate = NSPredicate(format: "ANY tags in %@", filterTokens)
            predicates.append(tokenPredicate)
        }

        if filterEnabled {
            if filterPriority >= 0 {
                let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityFilter)
            }

            if filterStatus != .all {
                let lookForClosed = filterStatus == .closed
                let statusFilter = NSPredicate(format: "comledted = %@", NSNumber(value: lookForClosed))
                predicates.append(statusFilter)
            }
        }

        let request = Issue.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let allIssues = (try? container.viewContext.fetch(request)) ?? []

        return allIssues
    }

    func newIssue() {
        let issue = Issue(context: container.viewContext)
        issue.title = NSLocalizedString("New Issue", comment: "Create a new issue")
        issue.creationDate = .now
        issue.priority = 1

        if let tag = selectedFilter?.tag {
            issue.addToTags(tag)
        }

        save()

        selectedIssue = issue
    }

    func newTag() {
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = NSLocalizedString("New Tag", comment: "Create a new tag")
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "issues":
            // certain nr of issues
            let fetchRequest = Issue.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "closed":
            // return true if they closed a certain nr of issues
            let fetchRequest = Issue.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "tags":
            // return true if they creqated a certain nr of tags
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
            // unknown award criterion; this should never be allowed
            // fatalError("Unknown criterion for award: \(award.criterion)")
            return false
        }
    }
}
