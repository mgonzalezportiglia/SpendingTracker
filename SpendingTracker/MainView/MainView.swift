//
//  MainView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 29/01/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                // Card view
                HStack {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Card new brand blue 123")
                            .font(.system(.title2))
                            .fontWeight(.bold)
                        
                        Text("Balance: $5.000")
                        Text("1234 1234 1234 5555")
                            .font(.system(.body, design: .monospaced))
                        
                        HStack {
                            Text("Credit limit: $5.555")
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Valid Thru")
                                Text("06/26")
                            }
                        }
                    }
                    .font(.system(size: 18))
                    .foregroundColor(Color.white)
                    .padding()
                    
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                // / Card View
            }
            .navigationTitle(Text("Expense schedule"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
