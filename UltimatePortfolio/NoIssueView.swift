//
//  NoIssueView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 03.02.26.
//

import SwiftUI

struct NoIssueView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Text("No Issue Selected")
            .font(.title)
            .foregroundStyle(.secondary)
        
        Button("New Issue") {
            // make new Issue
        }
    }
}

#Preview {
    NoIssueView()
}
