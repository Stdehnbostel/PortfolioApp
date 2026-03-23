//
//  TagsMenuView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 23.03.26.
//

import SwiftUI

struct TagsMenuView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var issue: Issue
    
    var body: some View {
        Menu {
            // show each selected Tag first
            ForEach(issue.issueTag) {
                tag in
                Button {
                    issue.removeFromTags(tag)
                } label: {
                    Label(tag.tagName, systemImage: "checkmark")
                }
            }
            
            // now show unselecect Tags
            let otherTags = dataController.missingTags(from: issue)
            
            if otherTags.isEmpty == false {
                Divider()
                
                Section("Add tags") {
                    ForEach(otherTags) {
                        tag in
                        Button(tag.tagName) {
                            issue.addToTags(tag)
                        }
                    }
                }
            }
        } label: {
            Text(issue.issueTagsList)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(nil, value: issue.issueTagsList)
        }
    }
}

#Preview {
    TagsMenuView(issue: Issue.example)
}
