//
//  Awards.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.02.26.
//

import SwiftUI

struct AwardsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel
    @State private var showAwardDetails = false
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            viewModel.selectedAward = award
                            showAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(viewModel.color(for: award))
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel(viewModel.label(for: award))
                        .accessibilityHint(award.description)
                    }
                }
            }
            .navigationTitle("Awards")
            #if !os(watchOS)
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
            #endif
        }
        .macFrame(minWidth: 600)
        .alert(awardTitle, isPresented: $showAwardDetails) {
        } message: {
            Text(viewModel.selectedAward.description)
        }
    }
    var awardTitle: String {
        if viewModel.hasEarned(award: viewModel.selectedAward) {
            return "Unlocked \(viewModel.selectedAward.name)"
        }
        return "Locked"
    }
}

#Preview {
    AwardsView(dataController: DataController.preview)
        .environmentObject(DataController(inMemory: true))
}
