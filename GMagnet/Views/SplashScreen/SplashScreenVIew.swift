/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 14/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 How to add animated assets using Lottie in SwiftUI - https://designcode.io/swiftui-handbook-lottie-animation
 */

import SwiftUI

struct SplashScreenView: View {
    let gameColor = GameColor()
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    @State var countDownTimer = 0.0
    @State private var isActive = false
    @State var timerRunning = true
    @State var changeBackground = false
    var body: some View {
        //MARK: - Done Splash Screen Animation
        if isActive{
            ContentView()
        //MARK: - Splash Screen Animation View
        }else{
            ZStack{
                //Change background based on the splash screen animation speed
                if !changeBackground {
                    gameColor.blue.ignoresSafeArea()
                } else {
                    gameColor.darkblue.ignoresSafeArea()
                }
                
                VStack{
                    //Play the lottie view to play splash screen animation
                    LottieView()
                        .frame(width: 400, height: 400)
                    Text("Welcome to GMagnet")
                        .font(.custom("DynaPuff-Regular", size: 35))
                        .foregroundColor(!changeBackground ? gameColor.darkblue : gameColor.blue)
                    //Track the timer count
                    Text("")
                        .onReceive(timer){_ in
                            if countDownTimer >= 0 && timerRunning {
                                countDownTimer += 0.1
                                if round(countDownTimer * 10) / 10.0 == 3.2 {
                                    //change background after 3.2s
                                    changeBackground = true
                                }
                                if round(countDownTimer * 10) / 10.0 == 5.5 {
                                    //end splash screen view after 5.5s
                                    timerRunning = false
                                }
                            } else {
                                self.isActive = true
                            }
                        }
                }
            }
        }
    }
    
    struct SplashScreenView_Previews: PreviewProvider {
        static var previews: some View {
            SplashScreenView()
        }
    }
}
