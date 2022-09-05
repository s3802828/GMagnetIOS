//
//  SignInView1.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 02/09/2022.
//

import SwiftUI

struct Home: View {
    @State var maxCircleHeight: CGFloat = 0
    @State var showSignUpView = false
    let gameColor = GameColor()
    var body: some View {
        VStack{
            GeometryReader{proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    ZStack{
                        Circle()
                            .fill(gameColor.black)
                            .offset(x: getRect().width/2, y: -height / 1.2)
                        
                        Circle()
                            .fill(gameColor.black)
                            .offset(x: -getRect().width/2, y: -height / 1.3)
                        
                        Circle()
                            .fill(gameColor.cyan)
                            .offset(y: -height / 1.3)
                            .rotationEffect(.init(degrees:0))
                        Spacer(minLength: 40)
                        Image("logo")
                            .scaledToFit()
                            .frame(width: 300, height: 200)
                    }
                    
                )

            }
            ZStack{
                if showSignUpView{
                    SignUpView()
                        .transition(.move(edge: .trailing))
                }
                else{
                    SignInView()
                        .transition(.move(edge: .trailing))
                }
            }
            Spacer()
            
        }
        .overlay(
            HStack{
                Text(showSignUpView ? "New Member?" : "Already Member?")
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                Button(action: {
                    withAnimation{
                        showSignUpView.toggle()
                    }
                }, label: {
                    Text(showSignUpView ? "Sign in":"Sign up")
                        .fontWeight(.bold)
                        .foregroundColor(gameColor.cyan)
                })
                
            
        }
            ,alignment: .bottom
            )
        }
    }

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
}
