//
//  AddTransactionFormView.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 31/01/2023.
//

import SwiftUI

struct AddTransactionFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var description = ""
    @State private var price = ""
    @State private var tags = ""
    @State private var tagName = ""
    @State private var dateSelection = Date()
    @State private var setSelectedTags: Set<Tag> = Set<Tag>()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.timestamp, ascending: true)], animation: .default) private var categoriesTag: FetchedResults<Tag>
    
    let card: Card?
    
    init(card: Card? = nil) {
        print("Executing init from AddTransactionFormView")
        self.card = card
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $description)
                    TextField("Price", text: $price)
                    DatePicker("Date", selection: $dateSelection, displayedComponents: .date)
                    NavigationLink("Tags") {
                        Form {
                            Section {
                                ForEach(categoriesTag) { category in
                                    Button {
                                        
                                        if !setSelectedTags.contains(category) {
                                            setSelectedTags.insert(category)
                                        } else {
                                            setSelectedTags.remove(category)
                                        }
                                        
                                    } label: {
                                        HStack {
                                            Text(category.name ?? "")
                                                .foregroundColor(.black)
                                            Spacer()
                                            
                                            if setSelectedTags.contains(category) {
                                                Image(systemName: "checkmark.circle")
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: deleteItems)
                            } header: {
                                Text("Tags selection")
                            }
                            Section {
                                TextField("Tag name", text: $tagName)
                                Button {
                                    let newTag = Tag(context: viewContext)
                                    
                                    newTag.timestamp = Date()
                                    newTag.name = self.tagName
                                    
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        print("An error appears while saving new tag: \(error)")
                                    }
                                } label: {
                                    Text("Save")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                
                            } header: {
                                Text("Add tag")
                            }
                        }
                        .navigationTitle("Tags form")
                    }
                } header: {
                    Text("information")
                }
                Section {
                    /* con el .self le decimos a swift que cada item es identificable
                     por su mismo valor */
                    if let arraySelectedTag = Array(setSelectedTags) {
                        ForEach(0..<arraySelectedTag.count, id: \.self) { index in
                            Text("\(arraySelectedTag[index].name ?? "")")
                        }
                    }
                } header: {
                    Text("Selectd tags")
                }
                Section {
                    Button("Select photo") {
                        print(setSelectedTags)
                    }
                } header: {
                    Text("Photo / Receipe")
                }
            }
            .onAppear(perform: cleanSelectedTags)
            .navigationTitle("Add transaction form")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        
                        let transaction = TransactionCard(context: viewContext)
                        
                        transaction.timestamp = self.dateSelection
                        transaction.name = self.description
                        transaction.price = Double(self.price) ?? 0
                        //transaction.image
                        //transaction.tag
                        transaction.card = self.card
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print("An error ocurrs while saving a new transaction: \(error)")
                        }
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
        
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { categoriesTag[$0] }.forEach(viewContext.delete)
                        
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func cleanSelectedTags() {
        //CLEAN set SELECTED TAGS
        for tagCategory in setSelectedTags {
            if(!categoriesTag.contains(tagCategory)) {
                setSelectedTags.remove(tagCategory)
            }
        }
    }
}

struct AddTransactionFormView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        AddTransactionFormView(card: nil)
            .environment((\.managedObjectContext), viewContext)
    }
}
