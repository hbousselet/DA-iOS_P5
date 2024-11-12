//
//  MoneyTransferView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct MoneyTransferView: View {
    @ObservedObject var viewModel = MoneyTransferViewModel()

    @State private var animationScale: CGFloat = 1.0
    @State private var showingAlert = false


        var body: some View {
            VStack(spacing: 20) {
                // Adding a fun header image
                Image(systemName: "arrow.right.arrow.left.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(hex: "#94A684"))
                    .padding()
                    .scaleEffect(animationScale)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                            animationScale = 1.2
                        }
                    }
                
                Text("Send Money!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)

                VStack(alignment: .leading) {
                    Text("Recipient (Email or Phone)")
                        .font(.headline)
                    TextField("Enter recipient's info", text: $viewModel.recipient)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .keyboardType(.emailAddress)
                }
                
                VStack(alignment: .leading) {
                    Text("Amount (€)")
                        .font(.headline)
                    TextField("0.00", text: $viewModel.amount)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .keyboardType(.decimalPad)
                }

                Button(action: {
                    if isRecipientWellFormattedForPhoneNumber(viewModel.recipient) && isValidAmount(viewModel.amount) {
                        viewModel.sendMoney()
                    } else {
                        showingAlert = true
                    }
                }
                ) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Send")
                    }
                    .padding()
                    .background(Color(hex: "#94A684"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Wrong format"),
                                message: Text("You entered a recipient or an invalid amount, please retry"),
                                dismissButton: .destructive(Text("Exit")))
                        }

                // Message
                if !viewModel.transferMessage.isEmpty {
                    Text(viewModel.transferMessage)
                        .padding(.top, 20)
                        .transition(.move(edge: .top))
                }
                
                Spacer()
            }
            .padding()
            .onTapGesture {
                        self.endEditing(true)  // This will dismiss the keyboard when tapping outside
                    }
        }
    
    private func isValidAmount(_ amount: String) -> Bool {
        guard let n = Decimal(string: amount) else { return false }
        print(n)
        if n.significantFractionalDecimalDigits >= -2 && n > 0 {
            return true
        } else {
            return false
        }
    }

    func isRecipientWellFormattedForPhoneNumber(_ recipient: String) -> Bool {
        var isPhoneNumberValid = false
        let phoneRegex = try? NSRegularExpression(pattern: "^(\\+33[1-9]|0[1-9])[1-9]\\d{8}$", options: .caseInsensitive)
        if let regex = phoneRegex {
            let range = NSRange(location: 0, length: recipient.utf16.count)
            let matches = regex.matches(in: recipient, range: range)
            isPhoneNumberValid = matches.count > 0
        } else {
            isPhoneNumberValid = false
        }
        return isPhoneNumberValid
    }
    
    private func isRecipientWellFormattedForEmail(_ recipient: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: recipient)
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
