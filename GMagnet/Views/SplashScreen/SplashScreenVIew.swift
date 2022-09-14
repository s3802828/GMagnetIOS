

import SwiftUI

struct SplashScreenView: View {
    let gameColor = GameColor()
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    @State var countDownTimer = 0.0
    @State private var isActive = false
    @State var timerRunning = true
    @State var changeBackground = false
    var body: some View {
        if isActive{
            ContentView()
        }else{
            ZStack{
                if !changeBackground {
                    gameColor.blue.ignoresSafeArea()
                } else {
                    gameColor.darkblue.ignoresSafeArea()
                }
                
                VStack{
                    LottieView()
                        .frame(width: 400, height: 400)
                    Text("Welcome to GMagnet")
                        .font(.custom("DynaPuff-Regular", size: 35))
                        .foregroundColor(!changeBackground ? gameColor.darkblue : gameColor.blue)
                    Text("")
                        .onReceive(timer){_ in
                            if countDownTimer >= 0 && timerRunning {
                                countDownTimer += 0.1
                                if round(countDownTimer * 10) / 10.0 == 3.2 {
                                    changeBackground = true
                                }
                                if round(countDownTimer * 10) / 10.0 == 5.5 {
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
