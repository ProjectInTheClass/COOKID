//
//  MealDetailView.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/12.
//
import SwiftUI
import Kingfisher


struct MealDetailView: View {
    @State var edit: Bool = false
    @State var isDineOut: Bool = false
    @State var image = UIImage()
    @Namespace var namespace
    
    var deleteTapped: (() -> Void)
    var saveTapped: ((Meal) -> Void)
    var cancelTapped: (() -> Void)
    
    var meal : Meal
    
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ZStack {
                if !edit {
                    VStack(spacing: 0) {
                        HStack {
                            Text("삭제")
                                .bold()
                                .foregroundColor(.red)
                                .onTapGesture {
                                    deleteTapped()
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
                            //Image(systemName: "camera.circle")
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .background(
                                    Color.clear
                                        .matchedGeometryEffect(id: "cameraButton",
                                                               in: namespace,
                                                               isSource: !edit)
                                )
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                                .padding()
                                .onAppear {
                                    fetchImage()
                                }
                            
                            
                            
                            VStack(alignment: .center, spacing: 8) {
                                HStack(alignment: .center, spacing: 18) {
                                    Text(meal.name)
                                        .matchedGeometryEffect(id: "mealName", in: namespace, isSource: !edit)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .lineLimit(1)
                                    Text(isDineOut ? "💸" + meal.mealType.rawValue : "🍚" + meal.mealType.rawValue)
                                        .font(.system(size: 18, weight: .regular, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.7))
                                }
                                
                                
                                Divider()
                                
                                HStack(alignment: .center, spacing: 16) {
                                    Text(meal.date.dateToString())
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.7))
                                    Text(meal.mealTime.rawValue)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.7))
                                        .padding(2)
                                        .background(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 0.4))
                                }
                                
                                if meal.mealType == .dineOut {
                                    Divider()
                                    
                                    HStack(alignment: .center, spacing: 16) {
                                        Text(intToString(value: meal.price))
                                            .font(.system(size: 21, weight: .thin, design: .rounded))
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
                    .onTapGesture {
                        cancelTapped()
                    }
                } else {
                    if #available(iOS 14.0, *) {
                        ModifyMealView(isDineOut: $isDineOut,
                                       cancelTapped: cancelTapped,
                                       saveTapped: saveTapped,
                                       namespace: namespace,
                                       meal: meal)
                    } else {
                        ModifyMealViewForAvailable(meal: meal)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .onAppear {
                if meal.mealType == .dineOut {
                    isDineOut = true
                } else if meal.mealType == .dineIn {
                        isDineOut = false
                }
            }
        } else {
            ZStack {
                if !edit {
                    VStack(spacing: 0) {
                        HStack {
                            Text("삭제")
                                .bold()
                                .foregroundColor(.red)
                                .onTapGesture {
                                    deleteTapped()
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
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .padding(.vertical)
                        
                        HStack {
                            Image(systemName: "camera.circle")
                                .font(.system(size: 40))
                                .foregroundColor(.black.opacity(0.6))
                                .frame(width: 100, height: 100)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                                .padding()
                            
                            
                            VStack(alignment: .center, spacing: 8) {
                                HStack(alignment: .center, spacing: 18) {
                                    Text(meal.name)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .lineLimit(1)
                                    Text(isDineOut ? "💸" + meal.mealType.rawValue : "🍚" + meal.mealType.rawValue)
                                        .font(.system(size: 18, weight: .regular, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.7))
                                }
                                
                                
                                Divider()
                                
                                HStack(alignment: .center, spacing: 16) {
                                    Text(meal.date.dateToString())
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.7))
                                    Text(meal.mealTime.rawValue)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.black.opacity(0.7))
                                        .padding(2)
                                        .background(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 0.4))
                                }
                                
                                if meal.mealType == .dineOut {
                                    Divider()
                                    
                                    HStack(alignment: .center, spacing: 16) {
                                        Text(intToString(value: meal.price))
                                            .font(.system(size: 21, weight: .thin, design: .rounded))
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
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding()
                    .shadow(radius: 20)
                    .onTapGesture {
                        cancelTapped()
                    }
                } else {
                    if #available(iOS 14.0, *) {
                        ModifyMealView(isDineOut: $isDineOut,
                                       cancelTapped: cancelTapped,
                                       saveTapped: saveTapped,
                                       namespace: namespace,
                                       meal: meal)
                    } else {
                        ModifyMealViewForAvailable(meal: meal)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.clear)
        }
    }
    
    
     func fetchImage() {
        if let imageUrl = meal.image {
            KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
                let image = try? result.get().image
                if let image = image {
                    self.image = image
                }
            }
        }
    }
}


