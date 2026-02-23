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
        toolbar {
            Menu {
                Button {
                    UIPasteboard.general.string = issue.issueTitle
                } label: {
                    Label("Copy Issue Title", systemImage: "doc.on.doc")
                }
                
                Button {
                    issue.completed.toggle()
                    dataController.save()
                } label: {
                    Label(issue.completed ? "Re-open Issue" : "Close Issue", systemImage: "bubble.left.and.bubble.right")
                }
            } label: {
                Label("Actions", systemImage: "ellipsis")
            }
        }
    }
}

#Preview {
    IssueView(issue: .example)
}
