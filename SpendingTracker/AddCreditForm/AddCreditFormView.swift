//
//  AddCreditFormView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 30/01/2023.
//

import SwiftUI
import UIKit

struct AddCreditFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name = ""
    @State private var number = ""
    @State private var limit = ""
    @State private var selectedTypeCard: TypeCard = .visacard
    @State private var yearExpiration = 2022
    @State private var monthExpiration = 1
    @State private var color: Color = .blue
    
    
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

                        let card = Card(context: viewContext)
                        
                        card.timestamp = Date()
                        card.id = UUID()
                        
                        card.name = name
                        card.number = number
                        card.limit = Double(limit) ?? 0.0
                        card.type = selectedTypeCard.rawValue
                        card.month = String(monthExpiration)
                        card.year = String(yearExpiration)
                        card.colorR = Double(color.components.r)
                        card.colorG = Double(color.components.g)
                        card.colorB = Double(color.components.b)
                        card.colorA = Double(color.components.a)
                        
                        do {
                            try viewContext.save()
                            
                            dismiss()
                        } catch {
                            print("An error was catched during saved perform: \(error)")
                        }
                        
                        /*print("card to persist name: \(name), number: \(number), limit: \(limit), type: \(selectedTypeCard.id), month: \(monthExpiration), year: \(yearExpiration), color (red): \(Double(color.components.r)), color (green): \(Double(color.components.g)), color (blue): \(Double(color.components.b)), color (alpha): \(Double(color.components.a))")
                        
                        print("card context below")
                        print(card)*/
                    }
                    .buttonStyle(.borderedProminent)
        
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                     dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
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

extension Color {

    var components: (r: Double, g: Double, b: Double, a: Double) {
        
        typealias NativeColor = UIColor
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0,0,0,0) }
        
        return (Double(r), Double(g), Double(b), Double(a))
    }
}
    
struct AddCreditFormView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        AddCreditFormView()
            .environment((\.managedObjectContext), context)
    }
}
