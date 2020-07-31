//
//  ContentView.swift
//  iExpenses
//
//  Created by Maythem Alsodani on 7/24/20.
//  Copyright © 2020 Maythem Alsodani. All rights reserved.
//

import SwiftUI

struct customModifier: ViewModifier {
    var amountNumber: Int
    
    func body(content: Content) -> some View {
     
        var font = Font.system(size: 20, weight: .bold, design: .default)
        var foreground = Color.orange

        if amountNumber < 10 {
            font =  Font.system(size: 20, weight: .semibold, design: .rounded)
        } else if amountNumber > 10 && amountNumber < 100 {
            foreground = Color.blue
            font =  Font.system(size: 25, weight: .heavy, design: .rounded)
        } else if amountNumber > 100 && amountNumber < 1000 {
            foreground = Color.red
            font =  Font.system(size: 35, weight: .bold, design: .rounded)
        } else {
            foreground = Color.purple
            font =  Font.system(size: 45, weight: .heavy, design: .rounded)
        }
        
        return content
             .foregroundColor(foreground)
             .font(font)
    }
}

extension View {
    func styler(_ amountNumber: Int) -> some View {
        self.modifier(customModifier(amountNumber: amountNumber))
    }
}

struct ExpenseItems: Identifiable, Codable { //struct to represent a single item of expense, Codable gives the ability to archive and unarchive data
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject { //an array to store all of items with the ExpenseItem struct
    @Published var itemsArray = [ExpenseItems]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(itemsArray){
                UserDefaults.standard.set(encoded, forKey: "Items")
                //this block of code allows to save data but it doesn't allow us to reload the data in the case we exit the app and relaunch it again
            }
            
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItems].self, from: items) {
                self.itemsArray = decoded
                return
            }
        }

        self.itemsArray = []
    }
}

struct ContentView: View {
@State private var showingAddExpense = false
@ObservedObject var expenses = Expenses()

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.itemsArray) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                                .bold()
                            Text(item.type)
                        }
                        
                        Spacer()
                            Text("$\(item.amount)")
                               // .modifier(customModifier(amountNumber: item.amount))
                                .styler(item.amount)
                       
                    
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExepnses")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.showingAddExpense = true
                }){
                    Image(systemName: "plus.circle")
            })
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: self.expenses)
            }
        }
    }
    
    
    func removeItems(at offsets: IndexSet) {
        expenses.itemsArray.remove(atOffsets: offsets)
    }
}

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
