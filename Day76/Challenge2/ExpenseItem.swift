//
//  ExpenseItem.swift
//  iExpense
//
//  Created by 褚宣德 on 2023/9/21.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    // UUID – short for "universally unique identifier"
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
