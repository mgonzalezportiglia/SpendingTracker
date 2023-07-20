//
//  MainView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 29/01/2023.
//

import SwiftUI

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}

struct MainView: View {
    
    @State private var selectionCardHash = -1
    @State private var shouldPresentAddCreditForm = false
    @State private var shouldPresentEditCreditForm = false
    @State private var shouldPresentAddTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)], animation: .default) private var cards: FetchedResults<Card>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCard.timestamp, ascending: true)], animation: .default) private var transactions: FetchedResults<TransactionCard>

    
    var body: some View {
        NavigationView {
            ScrollView {
                
                  
                if !cards.isEmpty {
                    TabView(selection: $selectionCardHash) {
                        ForEach(cards) { card in
                            CardView(card: card, shouldEdit: {
                                shouldPresentEditCreditForm.toggle()
                            })
                                .padding(.bottom, 50)
                                .tag(card.hash)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .frame(height: 300)
                    .onAppear {
                        self.selectionCardHash = cards.first?.hash ?? -1
                    }
                    
                    VStack {
                        Button("+ Transaction") {
                            handleAddTransaction()
                        }
                        .padding()
                        .background(Color(.label))
                        .foregroundColor(Color(.systemBackground))
                        .font(.system(size: 18, weight: .bold))
                        .cornerRadius(5)
                        
                        
                        
                        Spacer()
                        
                        if let firstIndex = cards.firstIndex(where: {
                            $0.hash == selectionCardHash
                        }) {
                            let card = cards[firstIndex]
                                                        
                            ForEach(transactions.filter({$0.card === card})) { transaction in
                                TransactionsCardView(transaction: transaction)
                            }
                        }
                        
                    }
                    
                } else {
                    emptyCardsView
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddTransactionForm) {
                        if let firstIndex = cards.firstIndex(where: {
                            $0.hash == selectionCardHash
                        }) {
                            let card = cards[firstIndex]
                            AddTransactionFormView(card: card)
                        }
                    }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCreditForm) {
                        AddCreditFormView { card in
                            self.selectionCardHash = card.hash
                        }
                    }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentEditCreditForm) {
                        if let firstIndex = cards.firstIndex(where: {
                            $0.hash == selectionCardHash
                        }) {
                            let card = cards[firstIndex]
                            
                            AddCreditFormView(card: card) { card in
                                self.selectionCardHash = card.hash
                            }
                        }
                    }
                
            }.navigationTitle(Text("Expense schedule"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("+ Card") {
                            shouldPresentAddCreditForm.toggle()
                        }
                        .padding(.horizontal, 5)
                        .foregroundColor(Color(.systemBackground))
                        .font(.system(size: 18, weight: .bold))
                        .background(Color(.label))
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
    
    private func fetchCards() -> FetchRequest<Card> {
        return FetchRequest<Card>(entity: Card.entity(), sortDescriptors: [])
    }
    
}

struct TransactionsCardView: View {
    
    @State var shouldPresentTransactionSheet = false
    @Environment(\.managedObjectContext) private var viewContext
    
    let transaction: TransactionCard?
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                HStack {
                    
                    if let tags: Array<Tag> = self.transaction?.tag?.toArray()  {
                        ForEach(0..<tags.count, id: \.self) { index in
                            if let itemTag = tags[index] as? Tag {
                                Text("\(itemTag.name ?? "")")
                                    .padding(.horizontal, 5)
                                    .background(
                                        VStack {
                                            if let colorR = itemTag.colorR,
                                               let colorG = itemTag.colorG,
                                               let colorB = itemTag.colorB,
                                               let colorA = itemTag.colorA,
                                               let colorTag = Color(red: colorR, green: colorG, blue: colorB, opacity: colorA) {
                                                colorTag
                                            }
                                        }
                                    )
                                    .cornerRadius(5)
                                    .font(.system(size: 18, weight: .medium))
                            }
                        }
                    }
                    
                    Spacer()
                    Button {
                        shouldPresentTransactionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color.black)
                    }
                    .confirmationDialog("Remove transaction", isPresented: $shouldPresentTransactionSheet) {
                        Button("Remove", action: handleRemoveTransaction)
                    }
                }
                HStack {
                    Text("$ " + String(format: "%.2f", self.transaction?.price ?? 0))
                        .foregroundColor(Color.black)
                    Spacer()
                    Text(self.transaction?.name ?? "")
                        .foregroundColor(Color.black)
                }
                HStack {
                    Spacer()
                    Text("17/08")
                        .foregroundColor(Color.black)
                }
                
                if let image = self.transaction?.image,
                    let uiImage = UIImage(data: image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                } else {
                    Image("no-image-available")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                
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
