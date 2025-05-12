//
//  WelcomeScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 6/5/2025.
//

import SwiftUI

struct WelcomeScreen: View {
  @Binding var currentScreen: AppScreen


    var body: some View {
      VStack {
        Image("UTSImage")
          .renderingMode(.original)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 356, height: 466)
          .clipped()
          .overlay(alignment: .topLeading) {
            Group {
              Rectangle()
                .foregroundStyle(Color(.black).opacity(0.59))
              VStack(alignment: .leading, spacing: 11) {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                  .fill(.purple)
                  .frame(width: 72, height: 72)
                  .clipped()
                  .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.12), radius: 8, x: 0, y: 4)
                  .overlay {
                    Image("UTSLogo")
                      .renderingMode(.original)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .padding(10)
                  }
                VStack(alignment: .leading, spacing: 1) {
                  Text("UniViewer")
                    .font(.system(size: 50, weight: .medium, design: .default))
                    .foregroundColor(.white)
                  Text("Your one-stop shop for anything course related.")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .frame(alignment: .leading)
                    .clipped()
                    .multilineTextAlignment(.leading)
                }
              }
              .padding()
              .padding(.top, 42)
            }
          }
          .overlay(alignment: .bottom) {
            Group {

            }
          }
          .mask {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
          }
          .padding()
          .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
          .blur(radius: 0)
        VStack(spacing: 10) {
          Spacer()
            .frame(height: 50)
            .clipped()
          VStack(spacing: 19) {
            Button(action: { currentScreen = .login }, label: {
              Text("Login")
                .font(.system(.title, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.purple)
                .clipped()
                .frame(height: 60)
                .background(
                  RoundedRectangle(
                    cornerRadius: 50,
                    style: .continuous
                  )
                  .stroke(.purple, lineWidth: 2)

                )
            })
                   Button(action: { currentScreen = .register }, label: {
              Text("Register")
                .font(.system(.title, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding()
                .clipped()
                .foregroundColor(.purple)
                .frame(height: 60)
                .background(
                  RoundedRectangle(
                    cornerRadius: 50,
                    style: .continuous
                  )
                  .stroke(.purple, lineWidth: 2)

                )
            })
          }
          .padding(.horizontal, 60)
        }
        .padding(.horizontal)
        Spacer()

      }
    }
  }


#Preview {
    WelcomeScreen(currentScreen: .constant(.welcome))
}
