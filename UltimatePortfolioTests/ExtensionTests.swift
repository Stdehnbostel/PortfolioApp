//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Stefan on 30.03.26.
//

import CoreData
import Testing
@testable import UltimatePortfolio

class ExtensionTests: UltimatePortfolioTestsBaseTestCases {

    @Test func issueTitleUnwrap() {
        let issue = Issue(context: managedObjectContext)
        
        issue.title = "Example issue"
        #expect(issue.issueTitle == "Example issue", "changing title should also be reflected in issueTitle")
        
        issue.issueTitle = "Updated issue"
        #expect(issue.title == "Updated issue", "changing issueTitle should also be reflected in title")
    }
    
    @Test func issueContentUnwrap() {
        // Given
        let issue = Issue(context: managedObjectContext)
        
        // When
        issue.content = "Example issue"
        
        // Then
        #expect(issue.issueContent == "Example issue", "changing content should also be reflected in issueContent")
        
        // When
        issue.issueContent = "Updated issue"
        
        // Then
        #expect(issue.content == "Updated issue", "changing issueContent should also be reflected in content")
    }
    
    @Test func issueCreatenDateUnwrap() {
        // Given
        let issue = Issue(context: managedObjectContext)
        let testDate = Date.now
        
        // When
        issue.creationDate = testDate
        
        // Then
        #expect(issue.issueCreationDate == testDate, "changing creationDate should also be reflected in issuecreationDate")
    }
    
    @Test func issueTagsUnwrap() {
        let tag = Tag(context: managedObjectContext)
        let issue = UltimatePortfolio.Issue(context: managedObjectContext)
        
        #expect(issue.issueTags.count == 0, "A new issue should have no tags.")
        
        issue.addToTags(tag)
        
        #expect(issue.issueTags.count == 1, "Adding a tag to an issue should add it to the issues tags list.")
    }
    
    @Test func issueTagsList() {
        let tag = Tag(context: managedObjectContext)
        let issue = UltimatePortfolio.Issue(context: managedObjectContext)
        
        tag.name = "My Tag"
        
        issue.addToTags(tag)
        
        #expect(issue.issueTagsList == "My Tag", "Adding 1 tag to an issue should make issueTagList return the tag name.")
    }
    
   @Test func issueSortingStable() {
       let issue1 = UltimatePortfolio.Issue(context: managedObjectContext)
       issue1.title = "B issue"
       issue1.creationDate = .now
       let issue2 = UltimatePortfolio.Issue(context: managedObjectContext)
       issue1.title = "B issue"
       issue1.creationDate = .now.addingTimeInterval(1)
       let issue3 = UltimatePortfolio.Issue(context: managedObjectContext)
       issue3.title = "A issue"
       issue3.creationDate = .now.addingTimeInterval(100)
       
       let allIssues = [issue1, issue2, issue3]
       let sorted = allIssues.sorted()
       
       #expect([issue3, issue1, issue2] == sorted, "Sorting issue arrays should use name then creation date.")
    }
    
    @Test func tagIdUnwrap() {
        let tag = Tag(context: managedObjectContext)
        
        tag.id = UUID()
        #expect(tag.tagID == tag.id, "Changing id should also change tagID.")
    }
    
    @Test func tagNameUnwrap() {
        let tag = Tag(context: managedObjectContext)
        
        tag.name = "My Tag"
        #expect(tag.name == tag.tagName, "Changing tagName should also change tagName.")
    }
    
    @Test func tagActiveIssues() {
        let tag = Tag(context: managedObjectContext)
        let issue = Issue(context: managedObjectContext)
        
        #expect(tag.tagActiveIssues.count == 0, "Newly created tag should have no issues.")
        
        tag.addToIssues(issue)
        
        #expect(tag.tagActiveIssues.count == 1, "Tag should have 1 issue after adding.")
        
        issue.completed = true
        
        #expect(tag.tagActiveIssues.count == 0, "Tag should have 0 issues after 1 is marked as completed.")
    }
    
    @Test func tagSortingStable() {
        let tag1 = Tag(context: managedObjectContext)
        tag1.name = "B Tag"
        tag1.id = UUID()
        
        let tag2 = Tag(context: managedObjectContext)
        tag2.name = "B Tag"
        tag2.id = UUID(uuidString: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFF540ACC5")
        
        let tag3 = Tag(context: managedObjectContext)
        tag3.name = "A Tag"
        tag3.id = UUID()
        
        let allTags = [tag1, tag2, tag3]
        let sorted = allTags.sorted()
        
        #expect([tag3, tag1, tag2] == sorted, "Sorting tag array should use name then uuid.")
    }
    
    @Test func bundleDecodingAwards() {
        let awards = Bundle.main.decode("Awards.json", as: [Award].self)
        #expect(awards.isEmpty == false, "Awards.json should decode to a non-empty array.")
    }
    
    @Test func decodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableString.json", as: String.self)
        
        #expect(data == "never ask a starfish for directions.", "The string must match DecodableString.json.")
    }
    
    @Test func decodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableDictionary.json", as: [String: Int].self)
        
        #expect(data.count == 3, "There should be 3 items decoded from DecodableDictionary.json.")
        #expect(data["One"] == 1, "The string must match DecodableDictionary.json.")
    }
}
