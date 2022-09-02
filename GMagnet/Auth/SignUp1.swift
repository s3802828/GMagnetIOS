//
//  SignUp1.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 03/09/2022.
//

import SwiftUI

struct SignUp1: View {
    @State var fullname = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    let gameColor = GameColor()
    var body: some View {
        VStack{
            
            Text("Sign up")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Fullname")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("Pham van A", text: $fullname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                Text("User Name")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("ijustine@gmail.com", text: $email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,25)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                SecureField("12345", text: $password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Retype password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                SecureField("12345", text: $confirmPassword)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            
            Button(action: {}, label:{
                Image(systemName: "arrow.right")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .clipShape(Circle())
                    .shadow(color: gameColor.cyan.opacity(0.6), radius: 5, x: 0, y: 0)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top,10)
                Spacer()
            }
        .padding()
    }
}

struct SignUp1_Previews: PreviewProvider {
    static var previews: some View {
        SignUp1()
    }
}
