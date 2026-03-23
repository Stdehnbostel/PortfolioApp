//
//  UserFilterRow.swift
//  UltimatePortfolio
//
//  Created by Stefan on 23.03.26.
//

import SwiftUI

struct UserFilterRow: View {
    var filter: Filter
    var rename: (Filter) -> Void
    var delete: (Filter) -> Void
    
    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
                .badge(filter.activeIssueCount)
                .contextMenu {
                    Button {
                        rename(filter)
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        delete(filter)
                    } label: {
                        Label("Delete", systemImage: "thrash")
                    }
                }
                .accessibilityElement()
                .accessibilityLabel(filter.name)
                .accessibilityHint("^[\(filter.activeIssueCount) issues](inflect: true)")
        }
    }
}

#Preview {
    UserFilterRow(filter: Filter.all, rename: {_ in }, delete: {_ in })
}
