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
    
    var body: some View {
        NavigationView {
            ScrollView {
                TabView(selection: $selectionCard) {
                    ForEach(0..<3) { index in
                        CardView()
                            .padding(.bottom, 50)
                            .tag(index)
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
        }
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
