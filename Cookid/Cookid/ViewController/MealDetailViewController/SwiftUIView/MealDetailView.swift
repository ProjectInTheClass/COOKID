//
//  MealDetailView.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/12.
//

import SwiftUI

struct MealDetailView: View {
    @State var edit: Bool = false
    @State var delete: Bool = false
    @Namespace var namespace
    
    var meal = Meal(price: 9000, date: Date(), name: "오삼불고기", image: nil, mealType: .dineOut, mealTime: .dinner)
    
    var body: some View {
        ZStack {
            if !edit {
                VStack(spacing: 0) {
                    HStack {
                        Text("삭제")
                            .bold()
                            .foregroundColor(.red)
                            .onTapGesture {
                                delete.toggle()
                                
                            }
                        Spacer()
                        Text("수정")
                            .bold()
                            .foregroundColor(.blue)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    edit.toggle()
                                }
                            }
                    }
                    .matchedGeometryEffect(id: "navBarItem", in: namespace, isSource: !edit)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.vertical)
                    
                    HStack {
                        Image(systemName: "camera.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.black.opacity(0.6))
                            .frame(width: 100, height: 100)
                            .background(
                                Color.black.opacity(0.3)
                                    .matchedGeometryEffect(id: "cameraButton",
                                                           in: namespace,
                                                           isSource: !edit)
                            )
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                            .padding()
                        
                        
                        VStack(alignment: .center, spacing: 8) {
                            HStack(alignment: .center, spacing: 18) {
                                Text(meal.name ?? "오삼불고기")
                                    .matchedGeometryEffect(id: "mealName", in: namespace, isSource: !edit)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .lineLimit(1)
                                Text(meal.mealType.rawValue ?? "🍚집밥")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                            
                            
                            Divider()
                            
                            HStack(alignment: .center, spacing: 16) {
                                Text(meal.date.dateToString() ?? "2021년 7월 11일")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.black.opacity(0.7))
                                Text(meal.mealTime.rawValue ?? "점저")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.black.opacity(0.7))
                                    .padding(2)
                                    .background(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 0.4))
                            }
                            
                            if meal.mealType == .dineOut {
                                Divider()
                                
                                HStack(alignment: .center, spacing: 16) {
                                    Text("8,900원")
                                        .font(.system(size: 21, weight: .light, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.7))
                                }
                            }
                        }
                        .padding(.trailing)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                }
                .background(Color.white.matchedGeometryEffect(id: "background",
                                                              in: namespace,
                                                              isSource: !edit)
                )
                .cornerRadius(30)
                .padding()
                .shadow(radius: 20)
            } else {
                ModifyMealView(namespace: namespace, meal: meal)
            }
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView()
    }
}
