////
////  ModifyMealView.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/12.
////
//
import SwiftUI
import Combine
import Kingfisher

@available(iOS 14.0, *)
struct ModifyMealView: View {
    @State var image = UIImage()
    @State var currentDate = Date().dateToString()
    @State var selectedDate: Date?
    @State var mealName = ""
    @State var mealTime = ""
    @State var price = ""
    
    @State var selectionIndex = 0
    @State var mealType: MealType?
    
    @Binding var isDineOut: Bool 
    @State var isFocused: Bool = false
    @State var showImagePicker: Bool = false
    @State var isImageSelected: Bool = false
    @State var saveButtonTapped: Bool = false
    @State var cancel: Bool = false
    
    var disposeBag = Set<AnyCancellable>()
    var cancelTapped: (() -> Void)
    var saveTapped: (() -> Void)
    var namespace: Namespace.ID
    var meal: Meal
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                
                Text("취소")
                    .bold()
                    .foregroundColor(.red)
                    .onTapGesture {
                        cancelTapped()
                    }
                Spacer()
                Text("저장")
                    .bold()
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if isImageSelected {
                            MealRepository.shared.fetchingImageURL(mealID: meal.id!, image: image) { url in
                                meal.date = selectedDate ?? meal.date
                                meal.image = url
                                meal.mealTime = MealTime(rawValue: mealTime) ?? meal.mealTime
                                meal.mealType = mealType ?? meal.mealType
                                meal.name = mealName == "" ? meal.name : mealName
                                meal.price = (price == "" ? meal.price : Int(price))!
                            }
                        } else {
                            meal.date = selectedDate ?? meal.date
                            meal.image = meal.image
                            meal.mealType = mealType ?? meal.mealType
                            meal.mealTime = MealTime(rawValue: mealTime) ?? meal.mealTime
                            meal.name = mealName == "" ? meal.name : mealName
                            meal.price = (price == "" ? meal.price : Int(price))!
                        }
                        saveTapped()
                    }
                
            }
            .matchedGeometryEffect(id: "navBarItem", in: namespace)
            .padding(.top, 24)
            .padding(.horizontal)
            
            
            VStack {
                Button(action: {
                    showImagePicker = true
                }, label: {
                    ZStack(alignment: .top) {
                        if isImageSelected {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .onReceive(Just(image), perform: { newImage in
                                    if isImageSelected {
                                        MealRepository.shared.fetchingImageURL(mealID: meal.id!, image: newImage) { url in
                                            meal.image = url
                                        }
                                    } else {
                                        meal.image = meal.image
                                    }
                                })
                        } else {
                            KFImage.url(meal.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                })
            }
            .frame(width: 150, height: 150)
            .background(Color.clear.matchedGeometryEffect(id: "cameraButton", in: namespace))
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            .padding(.top, 30)
            
            // Switch
            VStack {
                HStack {
                    Toggle(isOn: $isDineOut, label: {
                        Text(isDineOut ? "외식" : "집밥")
                            .font(.body)
                            .foregroundColor(.gray)
                    })
                    .onReceive(Just(isDineOut), perform: { isDineOut in
                                if isDineOut {
                                    mealType = .dineOut
                                } else {
                                    mealType = .dineIn
                                }                    })
                    .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))))
                    
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
            }
            
            
            Divider()
            
            // price
            if isDineOut {
                VStack {
                    VStack {
                        HStack {
                            Text("가격")
                                .font(.body)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.leading, 40)
                        
                        VStack {
                            TextField("\(meal.price)", text: $price)
                                .keyboardType(.numberPad)
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
                }
            }
            
            // date
            VStack(spacing: 8) {
                HStack {
                    Text("날짜")
                        .font(.body)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                .padding(.leading, 40)
                
                VStack {
                    DatePickerTextField(placeHolder: meal.date.dateToString(), date: $selectedDate)
                    
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
            
            //mealTime
            VStack {
                HStack {
                    Text("식사시간")
                        .font(.body)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading, 40)
                
                VStack {
                    TextFieldWithPickerAsInputView(
                        data: MealTime.allCases.map { String($0.rawValue) },
                        placeholder: "\(meal.mealTime.rawValue)",
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
            
            // mealname
            VStack {
                HStack {
                    Text("메뉴")
                        .font(.body)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading, 40)
                
                VStack {
                    TextField("\(meal.name)", text: $mealName)
                        .matchedGeometryEffect(id: "mealName", in: namespace)
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
            }
            .padding(.bottom,30)
        }
        .background(Color.white.matchedGeometryEffect(id: "background", in: namespace))
        .cornerRadius(30)
        .padding()
        .shadow(radius: 20)
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(selectedImage: $image, isImageSelected: $isImageSelected)
        })
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

