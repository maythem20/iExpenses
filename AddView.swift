//
//  AddView.swift
//  iExpenses
//
//  Created by Maythem Alsodani on 7/28/20.
//  Copyright © 2020 Maythem Alsodani. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode)var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showAlert = false
    
    static let types = ["Business","Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
        .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItems(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.itemsArray.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showAlert = true
                }
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("⚠️ Error Message"), message: Text("You can only use numbers in the field amount"), dismissButton: .default(Text("continue")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
