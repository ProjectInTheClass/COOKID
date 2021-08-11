//////
//////  ModifyMealViewForAvailable.swift
//////  Cookid
//////
//////  Created by 임현지 on 2021/07/13.
//////
////
//import SwiftUI
//import Kingfisher
//
//struct ModifyMealViewForAvailable: View {
//    @State var image = UIImage()
//    @State var currentDate = Date().dateToString()
//    @State var selectedDate: Date?
//    @State var mealName = ""
//    @State var mealTime = ""
//    @State var price = ""
//    
//    @State var selectionIndex = 0
//    @State var mealType: MealType?
//    
//    @State var isDineOut = false
//    @State var isFocused: Bool = false
//    @State var showImagePicker: Bool = false
//    @State var isImageSelected: Bool = false
//    
//    @State var show: Bool = false
//    
//    var cancelTapped: (() -> Void)
//    var saveTapped: ((Meal) -> Void)
//    var meal: Meal
//    let mealRepo = MealRepository()
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack {
//                Text("취소")
//                    .bold()
//                    .foregroundColor(.red)
//                    .onTapGesture {
//                        cancelTapped()
//                    }
//                Spacer()
//                Text("저장")
//                    .bold()
//                    .foregroundColor(.blue)
//                    .onTapGesture {
//                        if isImageSelected {
//                            mealRepo.deleteImage(meal: self.meal)
//                            mealRepo.fetchingImageURL(mealID: meal.id, image: image) { url in
//                                meal.id = meal.id
//                                meal.date = selectedDate ?? meal.date
//                                meal.image = url
//                                meal.mealTime = MealTime(rawValue: mealTime) ?? meal.mealTime
//                                meal.mealType = isDineOut ? .dineOut : .dineIn
//                                meal.name = mealName == "" ? meal.name : mealName
//                                meal.price = (price == "" ? meal.price : Int(price))!
//                                saveTapped(self.meal)
//                            }
//                        } else {
//                            meal.id = meal.id
//                            meal.date = selectedDate ?? meal.date
//                            meal.image = meal.image
//                            meal.mealType = isDineOut ? .dineOut : .dineIn
//                            meal.mealTime = MealTime(rawValue: mealTime) ?? meal.mealTime
//                            meal.name = mealName == "" ? meal.name : mealName
//                            meal.price = (price == "" ? meal.price : Int(price))!
//                            saveTapped(self.meal)
//                        }
//                        
//                    }
//            }
//            .padding(.top, 24)
//            .padding(.horizontal)
//            
//            
//            VStack {
//                Image(uiImage: image)
//                    .font(.system(size: 40))
//                    .foregroundColor(.black.opacity(0.6))
//                    .frame(width: 150, height: 150)
//                    .background(
//                        Color.black.opacity(0.3)
//                        
//                    )
//                    .clipShape(Circle())
//                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
//                    .padding(.top, 30)
//                    .onTapGesture {
//                        showImagePicker = true
//                    }
//                    .onAppear {
//                        fetchImage()
//                    }
//            }
//            
//            // Switch
//            VStack {
//                HStack {
//                    Toggle(isOn: $isDineOut, label: {
//                        Text(isDineOut ? "외식" : "집밥")
//                            .font(.body)
//                            .foregroundColor(.gray)
//                    })
//                    .disabled(true)
//                }
//                .padding(.horizontal, 30)
//                .padding(.top, 20)
//            }
//            
//            Divider()
//            
//            // price
//            if isDineOut {
//                VStack {
//                    VStack {
//                        HStack {
//                            Text("가격")
//                                .font(.body)
//                                .foregroundColor(Color.gray)
//                            Spacer()
//                        }
//                        .padding(.leading, 40)
//                        
//                        VStack {
//                            TextField("\(meal.price)", text: $price)
//                                .keyboardType(.numberPad)
//                        }
//                        .frame(height: 44)
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
//                        .background(
//                            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                .stroke(Color.black.opacity(0.2))
//                        )
//                        .padding(.horizontal, 26)
//                    }
//                }
//            }
//            
//            // date
//            VStack(spacing: 8) {
//                HStack {
//                    Text("날짜")
//                        .font(.body)
//                        .foregroundColor(Color.gray)
//                    Spacer()
//                }
//                .padding(.leading, 40)
//                
//                VStack {
//                    DatePickerTextField(placeHolder: meal.date.dateToString(), date: $selectedDate)
//                }
//                .frame(height: 44)
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal)
//                .background(
//                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                        .stroke(Color.black.opacity(0.2))
//                )
//                .padding(.horizontal, 26)
//            }
//            
//            //mealTime
//            VStack {
//                HStack {
//                    Text("식사시간")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//                .padding(.leading, 40)
//                
//                VStack {
//                    TextFieldWithPickerAsInputView(
//                        data: MealTime.allCases.map { String($0.rawValue) },
//                        placeholder: "\(meal.mealTime.rawValue)",
//                        selectionIndex: $selectionIndex,
//                        text: $mealTime)
//                }
//                .frame(height: 44)
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal)
//                .background(
//                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                        .stroke(Color.black.opacity(0.2))
//                )
//                .padding(.horizontal, 26)
//            }
//            
//            // mealname
//            VStack {
//                HStack {
//                    Text("메뉴")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//                .padding(.leading, 40)
//                
//                VStack {
//                    TextField("\(meal.name)", text: $mealName)
//                        .frame(height: 44)
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
//                        .background(
//                            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                .stroke(Color.black.opacity(0.2))
//                        )
//                        .padding(.horizontal, 26)
//                        .onTapGesture {
//                            isFocused = true
//                        }
//                }
//            }
//            .padding(.bottom,30)
//        }
//        .background(Color.white)
//        .cornerRadius(20)
//        .padding()
//        .shadow(radius: 20)
//        .sheet(isPresented: $showImagePicker, content: {
//            ImagePicker(selectedImage: $image, isImageSelected: $isImageSelected)
//        })
//        .onAppear {
//            if meal.mealType == .dineOut {
//                isDineOut = true
//            }
//        }
//    }
//    
//    
//    func fetchImage() {
//        if let imageUrl = meal.image {
//            KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
//                let image = try? result.get().image
//                if let image = image {
//                    self.image = image
//                }
//            }
//        }
//        if meal.image == nil {
//            self.image = UIImage(imageLiteralResourceName: "placeholder")
//                .resizableImage(withCapInsets: .init(), resizingMode: .tile)
//        }
//    }
//}