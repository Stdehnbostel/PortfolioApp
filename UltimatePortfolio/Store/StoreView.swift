//
//  StoreView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.06.26.
//

import SwiftUI
import StoreKit

struct StoreView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @State private var showingPurchseError = false
    
    enum LoadState {
        case loading, loaded, error
    }
    
    @State private var loadState = LoadState.loading
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    Image(decorative: "unlock")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Upgrade Today!")
                        .font(.title.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    Text("Get the most out of our app")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.blue.gradient)
                
                ScrollView {
                    VStack {
                        switch loadState {
                        case .loading:
                            Text("Fetching Offers...")
                                .font(.title2.bold())
                                .padding(.top, 50)
                            ProgressView()
                                .controlSize(.large)
                        case .loaded:
                            ForEach(dataController.products) { product in
                                Button {
                                    purchase(product)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(product.displayName)
                                                .font(.title2.bold())
                                            
                                            Text(product.description)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(product.displayPrice)
                                            .font(.title)
                                            .fontDesign(.rounded)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(.gray.opacity(0.2), in: .rect(cornerRadius: 20))
                                    .contentShape(.rect)
                                }
                            }
                            .buttonStyle(.plain)
                            
                            
                            
                        case .error:
                            Text("Sorry there was an error loading our store")
                                .padding(.top, 50)
                            
                            Button("try Again") {
                                Task {
                                    await load()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            
                        }
                    }
                    .padding(20)
                }
                Button("Restore Purchases", action: restore)
                
                Button("Cancel") {
                    dismiss()
                }
                .padding(.top, 20)
            }
        }
        .alert("In-app purchases are disabled", isPresented: $showingPurchseError) {
            
        } message: {
            Text("""
            You can't purchse the premium unlock because in-app purchases are disabled on this device.
            
            Please ask whomever manages your device for assistance.
            """)
        }
        .onChange(of: dataController.fullVersionUnlock) {
            checkForPurchase()
        }
        .task {
            await load()
        }
    }
    
    func checkForPurchase() {
        if dataController.fullVersionUnlock {
            dismiss()
        }
    }
    
    func purchase(_ product: Product) {
        guard AppStore.canMakePayments else {
            showingPurchseError.toggle()
            return
        }
        Task { @MainActor in
            try await dataController.purchase(product)
        }
    }
    
    func load() async {
        loadState = .loaded
        do {
            try await dataController.loadProducts()
            
            if dataController.products.isEmpty {
                loadState = .error
            } else {
                loadState = .loaded
            }
        } catch {
            loadState = .error
        }
    }
    
    func restore() {
        Task {
            try await AppStore.sync()
        }
    }
}

#Preview {
    StoreView()
}
