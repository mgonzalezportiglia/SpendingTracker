//
//  AddTransactionFormView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 31/01/2023.
//

import SwiftUI

struct AddTransactionFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Description", text: $description)
                } header: {
                    Text("information")
                }
            }
            .navigationTitle("Add transaction form")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        
                    }
                    .padding(.horizontal)
                    .background(Color.blue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct AddTransactionFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionFormView()
    }
}
