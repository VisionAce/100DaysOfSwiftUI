//
//  AddingConformanceToComparableForCustomTypes.swift
//  100DaysOfSwiftUI
//
//  Created by 褚宣德 on 2023/11/11.
//

import SwiftUI

struct User: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

struct ContentView: View {
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "List")
    ].sorted()
    
    var body: some View {
        VStack {
            List(users) { user in
                Text("\(user.firstName) \(user.lastName)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
