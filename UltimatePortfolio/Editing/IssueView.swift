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
    @Environment(\.openURL) var openURL
    @ObservedObject var issue: Issue
    
    @State private var showingNotificationsError = false

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField(
                        "Title",
                        text: $issue.issueTitle, prompt: Text("Enter your issue title here")
                    )
                    .labelsHidden()

                    Text(
                        // swiftlint:disable:next line_length
                        "**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))"
                    )
                    .foregroundStyle(.secondary)
                    Text(
                        "**Status:** \(issue.issueStatus)"
                    )
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

                    TextField(
                        "Description",
                        text: $issue.issueContent, prompt: Text("Enter your issue description here"), axis: .vertical
                    )
                    .labelsHidden()
                }
            }
            
            Section("Reminders") {
                Toggle("Show Reminders", isOn: $issue.reminderEnabled.animation())
                
                if issue.reminderEnabled {
                    DatePicker(
                        "Reminder Time",
                        selection: $issue.issueReminderDate,
                        displayedComponents: .hourAndMinute
                    )
                }
            }
        }
        .formStyle(.grouped)
        .disabled(issue.isDeleted)
        .onReceive(issue.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit {
            dataController.save()
        }
        .toolbar {
            IssueViewToolbar(issue: issue)
        }
        .alert("Oops", isPresented: $showingNotificationsError) {
            #if os(macOS)
            SettingsLink {
                Text("Check Settings")
            }
            #else
            Button("Check Settings", action: showSettings)
            #endif
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("There was a problem setting your notification. Please check you have notifications enabled.")
        }
        .onChange(of: issue.reminderEnabled) {
            updateReminder()
        }
        .onChange(of: issue.reminderTime) {
            updateReminder()
        }
    }
    
    #if os(iOS)
    func showSettings() {
        guard let settingsUrl = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
        
        openURL(settingsUrl)
    }
    #endif
    
    func updateReminder() {
        dataController.removeReminders(for: issue)
        
        Task { @MainActor in
            if issue.reminderEnabled {
                let success = await dataController.addReminder(for: issue)
                
                if success == false {
                    issue.reminderEnabled = false
                    showingNotificationsError = true
                }
            }
        }
    }
}

#Preview {
    IssueView(issue: .example)
}
