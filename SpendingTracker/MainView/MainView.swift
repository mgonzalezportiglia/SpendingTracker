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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCard.timestamp, ascending: true)], animation: .default) private var transactions: FetchedResults<TransactionCard>

    var body: some View {
        NavigationView {
            ScrollView {
                  
                if !cards.isEmpty {
                    TabView(selection: $selectionCard) {
                        ForEach(0..<cards.count) { index in
                            let card = cards[index]
                            CardView(card: card)
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .frame(height: 300)
                    
                    VStack {
                        Button("+ Transaction") {
                            handleAddTransaction()
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
                        
                        ForEach(transactions) { transaction in
                            TransactionsCardView(transaction: transaction)
                        }
                    }
                    
                } else {
                    emptyCardsView
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddTransactionForm) {
                        AddTransactionFormView(card: cards.first)
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
    
    private var emptyCardsView: some View {
        Text("NO CARDS FETCHED")
    }
    
    private func handleAddTransaction() -> Void {
        shouldPresentAddTransactionForm.toggle()
    }
    
}

struct TransactionsCardView: View {
    
    @State var shouldPresentTransactionSheet = false
    @Environment(\.managedObjectContext) private var viewContext
    
    let transaction: TransactionCard?
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Text("CATEGORY")
                    Text("CATEGORY")
                    Spacer()
                    Button {
                        shouldPresentTransactionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 26, weight: .bold))
                    }
                    .confirmationDialog("Remove transaction", isPresented: $shouldPresentTransactionSheet) {
                        Button("Remove", action: handleRemoveTransaction)
                    }
                }
                HStack {
                    Text("$ " + String(format: "%.2f", self.transaction?.price ?? 0))
                    Spacer()
                    Text(self.transaction?.name ?? "")
                }
                
                Image("no-image-available")
                    .resizable()
                    .scaledToFill()
            }
            .padding()
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
        .padding(.horizontal)

    }

    private func handleRemoveTransaction() -> Void {
        if let transactionToRemove = transaction {
            viewContext.delete(transactionToRemove)
            do {
                try viewContext.save()
            } catch  {
                print("An error ocurrs during deleted transaction: \(error)")
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        
        MainView()
            .environment((\.managedObjectContext), context)
    }
}
