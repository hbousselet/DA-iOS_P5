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
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
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
                    Task {
                        if (isRecipientWellFormattedForPhoneNumber(viewModel.recipient) || isRecipientWellFormattedForEmail(viewModel.recipient)) && isValidAmount(viewModel.amount) {
                            try? await viewModel.sendMoneyAsync()
                        } else {
                            showingAlert = true
                        }
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
                if !viewModel.transfertMessage.isEmpty {
                    Text(viewModel.transfertMessage)
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
        let pattern = "^\\d+(\\.\\d+)?$"
        guard amount.range(of: pattern, options: .regularExpression) != nil else {
            return false
        }
        guard let n = Decimal(string: amount) else { return false }
        if n.significantFractionalDecimalDigits <= 2 && n > 0 {
            return true
        } else {
            return false
        }
    }
    
    private func isRecipientWellFormattedForEmail(_ recipient: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print("email enered: \(recipient) and isValid: \(emailPred.evaluate(with: recipient))")
        return emailPred.evaluate(with: recipient)
    }
    func isRecipientWellFormattedForPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegex = "^(\\+33[1-9]|0[1-9])[0-9]{8}$"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        print("phone: \(phoneNumber) with regex: \(phoneNumberPredicate.evaluate(with: phoneNumber))")
        return phoneNumberPredicate.evaluate(with: phoneNumber)
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
