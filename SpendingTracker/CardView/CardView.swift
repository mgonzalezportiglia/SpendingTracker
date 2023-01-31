//
//  CardView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 29/01/2023.
//

import SwiftUI

struct CardView: View {
    
    @State private var shouldPresentCardSheet = false
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Card new brand blue 123")
                        .font(.system(.title2))
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        shouldPresentCardSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 26, weight: .bold))
                    }
                    .confirmationDialog("Remove card", isPresented: $shouldPresentCardSheet) {
                        Button("Remove") {
                            
                        }
                    } message: {
                        Text("Are you sure you want to delete this card?")
                    }
                    
                }
                
                HStack {
                    Image("mastercard")
                        .resizable()
                        .frame(width: 100, height: 65)
                    Spacer()
                    Text("Balance: $5.000")
                }
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
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue, Color.blue.opacity(0.3)]), startPoint: .bottomLeading, endPoint: .topTrailing)
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder()
        )
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
