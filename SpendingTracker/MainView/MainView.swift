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
                
                Text("The card selected is the number \(selectionCard)")
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCreditForm) {
                        AddCreditForm()
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

struct AddCreditForm: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Text("aasdasd")
                HStack {
                    Button("Dismiss bla") {
                       dismiss()
                    }
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
