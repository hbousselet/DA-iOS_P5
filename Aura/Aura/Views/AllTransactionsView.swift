//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Hugues Bousselet on 08/11/2024.
//

import SwiftUI

struct AllTransactionsView: View {
    var allTransactions: [AccountInfo.Transaction]
    @ObservedObject var viewModel: TransactionsViewModel

    
    init(allTransactions: [AccountInfo.Transaction]) {
        self.allTransactions = allTransactions
        self.viewModel = TransactionsViewModel(allTransactions: allTransactions)
    }
    var body: some View {
        if let model = viewModel.model {
            Form {
                ForEach(model) { currentTransaction in
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
