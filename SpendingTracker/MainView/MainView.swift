//
//  MainView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 29/01/2023.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectionCard = -1
    @State private var shouldPresentAddCreditForm = false
    @State private var shouldPresentAddTransactionForm = false
    
    @FetchRequest(sortDescriptors:[]) var cards: FetchedResults<Card>
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                /*TabView(selection: $selectionCard) {
                    ForEach(0..<3) { index in
                        CardView()
                            .padding(.bottom, 50)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(height: 300)*/
                
                if !cards.isEmpty {
                    TabView(selection: $selectionCard) {
                        ForEach(cards) { card in
                            CardView()
                                .padding(.bottom, 50)
                                .tag(card.id)
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 300)
                
                    VStack {
                        Button("+ Transaction") {
                            shouldPresentAddTransactionForm.toggle()
                        }
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .font(.system(size: 18, weight: .bold))
                        .cornerRadius(5)
                        
                        Text("The card selected is the number \(selectionCard)")
                        
                        Spacer()
                        
                        ForEach(cards) { card in
                            Text(card.name ?? "Unknown card")
                        }
                    }
                    
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddTransactionForm) {
                        AddTransactionFormView()
                    }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCreditForm) {
                        AddCreditFormView()
                    }
                
            }.navigationTitle(Text("Expense schedule"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("+ Card") {
                            shouldPresentAddCreditForm.toggle()
                        }
                        .padding(.horizontal, 5)
                        .foregroundColor(Color.white)
                        .font(.system(size: 18, weight: .bold))
                        .background(Color.black)
                        .cornerRadius(5)
                    }
                }
                .navigationViewStyle(.stack)
        }
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment((\.managedObjectContext), PersistenceController.shared.container.viewContext)
    }
}
