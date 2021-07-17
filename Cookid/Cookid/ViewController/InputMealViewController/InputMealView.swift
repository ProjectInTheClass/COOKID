////
////  InputShoppingListView.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/10.
////

import SwiftUI
import Combine

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
    
    @State var isFocused: Bool = false
    @State var showImagePicker: Bool = false
    @State var isEmpty: Bool = true
    @State var isImageSelected: Bool = false
    
    @State var meal: Meal?
    
    var dismissView: (() -> Void)
    var saveButtonTapped: (() -> Void)

    let mealRepo = MealRepository()
    
    var body: some View {
        ZStack(alignment: .top) {
                    VStack(spacing: 20) {
                        HStack {
                            Button(action: {dismissView()}, label: {
                                Text("취소")
                                    .bold()
                                    .foregroundColor(.red)
                            })
                            Spacer()
                            Button(action: {
                                withAnimation(.spring()) {
                                    if isImageSelected {

                                        mealRepo.deleteImage(meal: self.meal!)

                                        mealRepo.fetchingImageURL(mealID: mealName, image: image) { url in
                                            self.meal = Meal(
                                                id: "nil",
                                                price: Int(price) ?? 0,
                                                date: selectedDate ?? Date(),
                                                name: mealName,
                                                image: url ?? nil,
                                                mealType: mealType,
                                                mealTime: MealTime(rawValue: mealTime) ?? .breakfast)
                                            mealDelegate.meal = self.meal }
                                    } else { self.meal = Meal(id: "nil",
                                                         price: Int(price) ?? 0,
                                                         date: selectedDate ?? Date(),
                                                         name: mealName,
                                                         image: nil,
                                                         mealType: mealType,
                                                         mealTime: MealTime(rawValue: mealTime) ?? .breakfast)
                                        mealDelegate.meal = self.meal }
                                    saveButtonTapped()
                                    dismissView()
                                }
                            }, label: {
                                Text("저장")
                                    .bold()
                                    .foregroundColor(.blue)
                            })
                            .disabled(isEmpty ? true : false)
                        }
                        .padding(.top)
                        .padding(.horizontal, 26)
                        
                        // Image Button
                        
                        VStack {
                            Button(action: {
                                showImagePicker = true
                            }, label: {
                                ZStack {
                                    Image(systemName: "camera.circle")
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(.black.opacity(0.7))
                                .padding(.all, 30)
                                .frame(width: 280, height: 160, alignment: .center)
                                
                                .background(Color.gray.opacity(0.7))
                                .clipShape(RoundedRectangle(cornerRadius: 22.0, style: .continuous))
                                .shadow(color: .black.opacity(0.2), radius: 20, x: 1, y: 5)
                            })
                        }
                        
                        // Toggle View
                        VStack {
                            HStack {
                                if #available(iOS 14.0, *) {
                                    Toggle(isOn: $isDineOut, label: {
                                        Text(mealType.rawValue)
                                            .font(.body)
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
                                            .font(.body)
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
                        .padding(.top, 10)
                        
                        
                        Divider()
                        
                        
                        // Price TextField
                        if isDineOut {
                            VStack(spacing: 8) {
                                VStack {
                                    HStack {
                                        Text("가격")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding(.leading, 40)
                                    
                                    VStack {
                                        TextField("금액을 입력해 주세요.", text: $price)
                                            .keyboardType(.decimalPad)
                                    }
                                    .frame(height: 44)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                                            .stroke(Color.black.opacity(0.2))
                                    )
                                    .padding(.horizontal, 26)
                                }
                            } .transition(.opacity)
                        }
                        
                        
                        // Date Picker TextField
                        VStack(spacing: 8) {
                            HStack {
                                Text("날짜")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.leading, 40)
                            
                            VStack {
                                DatePickerTextField(placeHolder: currentDate, date: $selectedDate)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(Color.black.opacity(0.2))
                            )
                            .padding(.horizontal, 26)
                        }
                        
                        
                        // MealType Picker TextField
                        VStack(spacing: 8) {
                            HStack {
                                Text("식사시간")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.leading, 40)
                            
                            VStack {
                                TextFieldWithPickerAsInputView(
                                    data: MealTime.allCases.map { String($0.rawValue) },
                                    placeholder: "아침",
                                    selectionIndex: $selectionIndex,
                                    text: $mealTime)
                            }
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(Color.black.opacity(0.2))
                            )
                            .padding(.horizontal, 26)
                        }
                        
                        
                        // Menu TextField
                        VStack(spacing: 8) {
                            HStack {
                                Text("메뉴")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.leading, 40)
                            
                            VStack {
                                TextField("무엇을 드셨나요?", text: $mealName)
                                    .onReceive([self.mealName].publisher.first(), perform: { mealName in
                                        if mealName == "" {
                                            self.isEmpty = true
                                        } else {
                                            self.isEmpty = false
                                        }
                                    })
                                    .frame(height: 44)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    
                                    .background(
                                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                                            .stroke(Color.black.opacity(0.2))
                                    )
                                    .padding(.horizontal, 26)
                                    .onTapGesture {
                                        isFocused = true
                                    }
                            }
                            .padding(.bottom, 30)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 20)
                    .animation(isDineOut ? .easeIn : nil)
              
        }
        .padding(.horizontal, 30)
        .onAppear {
            
        }
        .onTapGesture {
            isFocused = false
            hideKeyboard()
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image, isImageSelected: $isImageSelected)
        })
        
    }
    
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}


struct preview : PreviewProvider{
    static var previews: some View {
        InputMealView(mealDelegate: InputMealViewDelegate(), dismissView: {}, saveButtonTapped: {})
    }
}
