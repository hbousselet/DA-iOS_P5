//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Hugues Bousselet on 08/11/2024.
//

import SwiftUI

struct AllTransactionsView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    var body: some View {
        if !viewModel.allTransactions.isEmpty {
            Form {
                ForEach(viewModel.allTransactions) { currentTransaction in
                    HStack{
                        Text("\(currentTransaction.id.description): \(currentTransaction.description)")
                        Spacer()
                        Text(currentTransaction.amount)
                            .foregroundColor(currentTransaction.amount.contains("+") ? .green : .red)
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Transactions history")
        }
    }
}
