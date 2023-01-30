//
//  AddCreditFormView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 30/01/2023.
//

import SwiftUI

struct AddCreditFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var number = ""
    @State private var limit = ""
    @State private var selectedTypeCard: TypeCard = .visacard
    @State private var yearExpiration = ""
    @State private var monthExpiration = ""
    @State private var color = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section  {
                    TextField("Name", text: $name)
                    TextField("Credit card number", text: $number)
                    TextField("Limit", text: $limit)
                    Picker(selection: $selectedTypeCard) {
                        
                    } label: {
                        Text("Type")
                    }

                } header: {
                    Text("Card information")
                }
                
                Section {
                    
                } header: {
                    Text("Expiration")
                }
                
                Section {
                    
                } header: {
                    Text("Color")
                }

            }
            .navigationTitle(Text("Add credit card form"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        
                    }
                    .padding()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                     dismiss()
                    }
                }
            }
        }
    }
}

enum TypeCard: String, CustomStringConvertible {
    case discovercard, mastercard, paypalcard, visacard
    var id: Self { self }
    
    var description: String {
        switch self {
        case .visacard: return "Visa"
        case .discovercard: return "Discover"
        case .mastercard: return "MasterCard"
        case .paypalcard: return "Paypal"
        }
    }
}

struct AddCreditFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddCreditFormView()
    }
}
