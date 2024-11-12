//
//  AllTransactionsViewModel.swift
//  Aura
//
//  Created by Hugues Bousselet on 08/11/2024.
//

import Foundation


class TransactionsViewModel: ObservableObject {
    
    @Published var allTransactions: [Transaction] = createTransactionObject(transactions: ApiService.allAccountTransactions)
    
    private static func createTransactionObject(transactions: [AccountInfo.Transaction]) -> [Transaction] {
        var businessTransaction = [Transaction]()
        var transactionId: Int = 1
        for transaction in transactions {
            businessTransaction.append(Transaction(description: transaction.label, amount: transaction.value.currencyString(), id: transactionId))
            transactionId += 1
        }
        return businessTransaction
    }
    
    struct Transaction: Identifiable {
        let description: String
        let amount: String
        
        var id: Int
    }
}
