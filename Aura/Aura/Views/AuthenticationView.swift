//
//  AuthenticationView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    
    let gradientStart = Color(hex: "#94A684").opacity(0.7)
    let gradientEnd = Color(hex: "#94A684").opacity(0.0) // Fades to transparent

    @ObservedObject var viewModel: AuthenticationViewModel

    
    var body: some View {
        
        ZStack {
                    // Background gradient
                    LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]), startPoint: .top, endPoint: .bottomLeading)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            
                        Text("Welcome !")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        TextField("Adresse email", text: $viewModel.username)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                        
                        SecureField("Mot de passe", text: $viewModel.password)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                        
                        Button(action: {
                            // Handle authentication logic here
                            if isValidEmail(viewModel.username) && !viewModel.password.isEmpty {
                                showingAlert = false
                                viewModel.login()
                            } else {
                                showingAlert = true
                            }
                        }) {
                            Text("Se connecter")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black) // You can also change this to your pastel green color
                                .cornerRadius(8)
                        }
                        .alert(isPresented:$showingAlert) {
                                    Alert(
                                        title: Text("Wrong format"),
                                        message: Text("You entered a wrong email adress or a wrong password, please retry"),
                                        dismissButton: .destructive(Text("Exit")))
                                }
                    }
                    .padding(.horizontal, 40)
                }
        .onTapGesture {
                    self.endEditing(true)  // This will dismiss the keyboard when tapping outside
                }
    }
    
}

private func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
