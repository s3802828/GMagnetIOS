/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 02/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- SwiftUI Login Page UI - Complex UI - SwiftUI Tutorials: https://www.youtube.com/watch?v=Ohr5oZW03Ok
*/


import SwiftUI
import GoogleSignInSwift

struct Home: View {
    @State var maxCircleHeight: CGFloat = 0
    @State var showSignUpView = false
    
    let gameColor = GameColor()
    var body: some View {
        VStack{
            //MARK: - Common header for sign in + sign up
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
            //MARK: - Content (sign up/login)
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
        //MARK: - Common footer
        .overlay(
            HStack{
                //if sign up, show "Already member?", otherwise, show "New member?"
                Text(showSignUpView ? "New Member?" : "Already Member?")
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                Button(action: {
                    withAnimation{
                        showSignUpView.toggle() //Toggle view between sign in / sign up
                    }
                }, label: {
                    //if sign up, show "Sign in", otherwise, show "Sign up"
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
