//
//  CardView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 29/01/2023.
//

import SwiftUI

struct CardView: View {
    
    let card: Card?
    
    init(card: Card? = nil) {
        self.card = card
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var shouldPresentCardSheet = false
    
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(self.card?.name ?? "")
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
                        Button("Remove", role: .destructive, action: handleRemove)
                    } message: {
                        Text("Are you sure you want to delete this card?")
                    }
                    
                }
                
                HStack {
                    Image(self.card?.type ?? "mastercard")
                        .resizable()
                        .frame(width: 100, height: 65)
                    Spacer()
                    Text("Balance: $5.000")
                }
                Text(self.card?.number ?? "")
                    .font(.system(.body, design: .monospaced))
                
                HStack {
                    Text("Credit limit: $ \(self.card?.limit ?? 0)")
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Valid Thru")
                        Text("\(self.card?.month ?? "")/ \(self.card?.year ?? "")")
                    }
                }
            }
            .font(.system(size: 18))
            .foregroundColor(Color.white)
            .padding()
            
            Spacer()
        }
        .background(
            
            VStack {
                if let colorR = self.card?.colorR,
                   let colorG = self.card?.colorG,
                   let colorB = self.card?.colorB,
                   let colorA = self.card?.colorA,
                   let color = Color(red: colorR, green: colorG, blue: colorB, opacity: colorA) {
                    LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.6)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                } else {
                    Color.purple
                }
            }
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder()
        )
        .padding()
    }
    
    private func handleRemove() -> Void {                
        if let cardToRemove = card {
         
            viewContext.delete(cardToRemove)
         
            do {
                try viewContext.save()
            } catch {
                print("Error ocurred during removing card: \(error)")
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        
        CardView(card: nil)
            .environment((\.managedObjectContext), context)
    }
}
