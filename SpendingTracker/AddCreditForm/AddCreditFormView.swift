//
//  AddCreditFormView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 30/01/2023.
//

import SwiftUI
import UIKit

struct AddCreditFormView: View {
    
    let card: Card?
    var didSaveCard: ((Card) -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name = ""
    @State private var number = ""
    @State private var limit = ""
    @State private var selectedTypeCard: TypeCard = .visacard
    @State private var yearExpiration = 2022
    @State private var monthExpiration = 1
    @State private var color: Color = .blue
    
    init(card: Card? = nil, didSaveCard: ((Card) -> ())? = nil) {
        self.card = card
        
        self._name = State(initialValue: self.card?.name ?? "")
        self._number = State(initialValue: self.card?.number ?? "")
        self._limit = State(initialValue: self.card?.limit.formatted() ?? "")
        self._color = State(initialValue: Color(red: self.card?.colorR ?? 0, green: self.card?.colorG ?? 0, blue: self.card?.colorB ?? 0, opacity: self.card?.colorA ?? 0))
        
        if let type = self.card?.type {
            self._selectedTypeCard = State(initialValue: TypeCard.init(rawValue: type)!)
        }
        
        if let month = self.card?.month {
            self._monthExpiration = State(initialValue: Int(month)!)
        }
        
        if let year = self.card?.year {
            self._yearExpiration = State(initialValue: Int(year)!)
        }
        
        self.didSaveCard = didSaveCard
        
    }
    
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
                    saveButton
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
    
    private var saveButton: some View {
        Button("Save") {

            let card = self.card != nil ? self.card! : Card(context: viewContext)
            
            card.timestamp = Date()
            card.id = UUID()
            
            card.name = self.name
            card.number = numberCardFormatter.string(from: NSNumber(value: Int(self.number)!))
            card.limit = Double(self.limit) ?? 0.0
            card.type = self.selectedTypeCard.rawValue
            card.month = String(self.monthExpiration)
            card.year = String(self.yearExpiration)
            card.colorR = Double(self.color.components.r)
            card.colorG = Double(self.color.components.g)
            card.colorB = Double(self.color.components.b)
            card.colorA = Double(self.color.components.a)
            
            do {
                try viewContext.save()
                
                dismiss()
                didSaveCard?(card)
            } catch {
                print("An error was catched during saved perform: \(error)")
            }
            
            /*print("card to persist name: \(name), number: \(number), limit: \(limit), type: \(selectedTypeCard.id), month: \(monthExpiration), year: \(yearExpiration), color (red): \(Double(color.components.r)), color (green): \(Double(color.components.g)), color (blue): \(Double(color.components.b)), color (alpha): \(Double(color.components.a))")
            
            print("card context below")
            print(card)*/
        }
        .buttonStyle(.borderedProminent)
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

private let numberCardFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.positiveFormat = "####,####"
    formatter.groupingSeparator = "  "
    return formatter
}()
    
struct AddCreditFormView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        AddCreditFormView(card: nil, didSaveCard: nil)
            .environment((\.managedObjectContext), context)
    }
}
