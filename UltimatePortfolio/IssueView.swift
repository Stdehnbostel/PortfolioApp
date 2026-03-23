//
//  IssueView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 03.02.26.
//

import SwiftUI
import CoreData

struct IssueView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var issue: Issue
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter your issue title here"))
                    
                    Text("**Modified:** \(issue.modificationDate?.formatted(date: .long, time: .shortened) ?? "Never modified")")
                    
                    Text("**Status:** \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                }
                
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                TagsMenuView(issue: issue)
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField("Description", text: $issue.issueContent, prompt: Text("Enter your issue description here"), axis: .vertical)
                }
            }
        }
        .disabled(issue.isDeleted)
        .onReceive(issue.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit {
            dataController.save()
        }
        toolbar {
            IssueViewToolbar(issue: issue)
        }
    }
}

#Preview {
    IssueView(issue: .example)
}
