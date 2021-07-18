////
////  InputShoppingListView.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/10.
////

import SwiftUI
import Combine
import Kingfisher

struct InputMealView: View {
    @ObservedObject var mealDelegate: InputMealViewDelegate
    
    @State var image = UIImage()
    @State var imageURL: URL?
    
    @State var currentDate = Date().dateToString()
    @State var selectedDate: Date?
    
    @State var mealName = ""
    @State var mealTime = ""
    
    @State var price = ""
    
    @State var selectionIndex = 0
    
    @State var isDineOut = false
    @State var mealType = MealType.dineIn
    
    @State var showActionSheet: Bool = false
    @State var isFocused: Bool = false
    @State var priceTFIsFocused: Bool = false
    @State var showImagePicker: Bool = false
    @State var isEmpty: Bool = true
    @State var isImageSelected: Bool = false
    @State var imageSourceStyle: UIImagePickerController.SourceType?
    
    @State var meal: Meal?
    
    var dismissView: (() -> Void)
    var saveButtonTapped: ((Meal) -> Void)
    
    let mealRepo = MealRepository()
    
    var body: some View {
        ZStack {
            ZStack {
                GeometryReader { proxy in
                    Color.black.opacity(0.7)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { dismissView() }
                
                VStack(spacing: 17) {
                    
                    // Image Button
                    VStack {
                        Button(action: {
                            showActionSheet = true
                        }, label: {
                            ZStack {
                                Image(systemName: "camera.fill")
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                            .font(.system(size: 30, weight: .regular, design: .rounded))
                            .foregroundColor(Color.white)
                            .frame(width: 130, height: 170)
                            .background(Color.gray.opacity(isImageSelected ? 0 : 0.2))
                            .clipShape(Circle())
                            .padding(.top, 15)
                            .shadow(color: .gray.opacity(0.2), radius: 20, x: 1, y: 5)
                        })
                        .actionSheet(isPresented: $showActionSheet, content: {
                            ActionSheet(title: Text("사진을 선택해 주세요"),
                                        message: Text("맛있게 드신 음식 사진을 골라주세요"),
                                        buttons: [
                                            .default(Text("앨범에서 선택하기"), action: {
                                                showImagePicker = true
                                                self.imageSourceStyle = .photoLibrary
                                            }),
                                            .default(Text("사진 찍기"), action: {
                                                showImagePicker = true
                                                self.imageSourceStyle = .camera
                                            }),
                                            .cancel(Text("취소"))
                                        ])
                        })
                    }
                    
                    
                                        
                    // Date Picker TextField
                    VStack(spacing: 5) {
                        HStack {
                            Text("📅  날짜")
                                .font(.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack {
                            DatePickerTextField(placeHolder: currentDate, date: $selectedDate)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 30)
                    
                    
                    // MealType Picker TextField
                    VStack(spacing: 5) {
                        HStack {
                            Text("⏳ 식사시간")
                                .font(.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack {
                            TextFieldWithPickerAsInputView(
                                data: MealTime.allCases.map { String($0.rawValue) },
                                placeholder: "아침",
                                selectionIndex: $selectionIndex,
                                text: $mealTime)
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 30)
                    
                    
                    // Menu TextField
                    VStack(spacing: 5) {
                        HStack {
                            Text("🧆 메뉴")
                                .font(.system(size: 16, weight: .light, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack {
                            TextField("무엇을 드셨나요?", text: $mealName)
                                .onReceive([self.mealName].publisher.first(), perform: { mealName in
                                    if mealName == "" {
                                        self.isEmpty = true
                                    } else {
                                        self.isEmpty = false
                                    }
                                })
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(.darkGray))
                                .onTapGesture {
                                    isFocused = true
                                    priceTFIsFocused = false
                                }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Toggle View
                    VStack {
                        HStack {
                            if #available(iOS 14.0, *) {
                                Toggle(isOn: $isDineOut, label: {
                                    Text(mealType.rawValue)
                                        .font(.system(size: 16, weight: .light, design: .default))
                                        .foregroundColor(.black)
                                })
                                .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))))
                                .onReceive([self.isDineOut].publisher.first()) { isDineOut in
                                    if isDineOut {
                                        self.mealType = .dineOut
                                    } else {
                                        self.mealType = .dineIn
                                    }
                                }
                            } else {
                                Toggle(isOn: $isDineOut, label: {
                                    Text(mealType.rawValue)
                                        .font(.system(size: 16, weight: .light, design: .default))
                                        .foregroundColor(.black)
                                })
                                .onReceive([self.isDineOut].publisher.first()) { isDineOut in
                                    if isDineOut {
                                        self.mealType = .dineOut
                                    } else {
                                        self.mealType = .dineIn
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                    
                    // Price TextField
                    if isDineOut {
                        VStack(spacing: 2) {
                            VStack {
                                HStack {
                                    Text("💸 가격")
                                        .font(.system(size: 16, weight: .light, design: .default))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                VStack {
                                    TextField("금액을 입력해 주세요.", text: $price)
                                        .keyboardType(.decimalPad)
                                        .foregroundColor(Color(.darkGray))
                                        .onTapGesture {
                                            priceTFIsFocused = true
                                            isFocused = false
                                        }
                                }
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 30)
                        .transition(.opacity)
                        
                    }
                    
                    
                    // 체크 버튼
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring()) {
                                if isImageSelected {
                                    mealRepo.fetchingImageURL(mealID: mealName, image: image) { url in
                                        self.meal = Meal(
                                            id: "nil",
                                            price: Int(price) ?? 0,
                                            date: selectedDate ?? Date(),
                                            name: mealName,
                                            image: url ?? nil,
                                            mealType: mealType,
                                            mealTime: MealTime(rawValue: mealTime) ?? .breakfast)
                                        mealDelegate.meal = self.meal
                                        saveButtonTapped(self.meal!)}
                                } else { self.meal = Meal(id: "nil",
                                                          price: Int(price) ?? 0,
                                                          date: selectedDate ?? Date(),
                                                          name: mealName,
                                                          image: nil,
                                                          mealType: mealType,
                                                          mealTime: MealTime(rawValue: mealTime) ?? .breakfast)
                                    mealDelegate.meal = self.meal
                                    saveButtonTapped(self.meal!)}
                                
                                dismissView()
                            }
                        }, label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(isImageSelected ? .yellow : .gray)
                                .foregroundColor(isEmpty ? .gray : .yellow)
                                .font(.system(size: 33))
                        })
                        .disabled(isEmpty ? true : false)
                        .disabled(!isImageSelected ? true : false)
                    }
                    .padding(.bottom, 24)
                    .padding(.trailing, 24)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 20)
                .padding(40)
                .animation(isDineOut ? .easeIn : nil)
                .offset(y: isFocused ? -200 : 0)
                .offset(y: priceTFIsFocused ? -200 : 0)
            }
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                isFocused = false
                priceTFIsFocused = false
                hideKeyboard()
            }
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(sourceType: self.imageSourceStyle!, selectedImage: $image, isImageSelected: $isImageSelected)
            })
        }
    }
}


struct preview : PreviewProvider{
    static var previews: some View {
        InputMealView(mealDelegate: InputMealViewDelegate(), dismissView: {}, saveButtonTapped: {_ in})
    }
}
