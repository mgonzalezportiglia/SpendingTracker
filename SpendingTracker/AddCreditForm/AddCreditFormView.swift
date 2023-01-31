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
    @State private var yearExpiration = 2022
    @State private var monthExpiration = 1
    @State private var color = Color.blue
    
    
    var body: some View {
        NavigationView {
            Form {
                Section  {
                    TextField("Name", text: $name)
                    TextField("Credit card number", text: $number)
                    TextField("Limit", text: $limit)
                    Picker(selection: $selectedTypeCard) {
                        ForEach(TypeCard.allCases) {
                            Text("\($0.description)")
                        }
                    } label: {
                        Text("Type")
                    }

                } header: {
                    Text("Card information")
                }
                
                Section {
                    Picker("Month", selection: $monthExpiration) {
                        ForEach(1..<13, id: \.self) {
                            Text(String($0))
                        }
                    }
                    Picker("Year", selection: $yearExpiration) {
                        ForEach(2022..<2040, id: \.self) {
                            Text(String($0))
                        }
                    }
                } header: {
                    Text("Expiration")
                }
                
                Section {
                    ColorPicker("Card color", selection: $color)
                } header: {
                    Text("Color")
                }

            }
            .navigationTitle(Text("Add credit card form"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        
                    }
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .font(.system(size: 16, weight: .bold))
                    .cornerRadius(8)
        
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

enum TypeCard: String, CustomStringConvertible, CaseIterable, Identifiable {
    var id: Self { self }
    
    case discovercard, mastercard, paypalcard, visacard
    
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
