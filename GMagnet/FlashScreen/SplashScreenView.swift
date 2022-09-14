

import SwiftUI

struct SplashScreenView: View {
    let gameColor = GameColor()
    @State private var isActive = false
    var body: some View {
        if isActive{
            SignUpView()
        }else{
            ZStack{
                gameColor.blue.ignoresSafeArea()
                VStack{
                LottieView()
                    .frame(width: 400, height: 400)
                    Text("Wellcome to GMagnet")
                        .font(.custom("DynaPuff-Regular", size: 35))
                        .foregroundColor(Color.gray)
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    self.isActive = true
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
