//
//  PSCityPickerView.h
//  Diamond
//
//  Created by Pan on 15/8/12.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSCityPickerView;

@protocol PSCityPickerViewDelegate <NSObject>

- (void)cityPickerViewValueChanged;

@end


@interface PSCityPickerView : UIPickerView

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;

@property (nonatomic, weak) id<PSCityPickerViewDelegate> cityPickerDelegate;

@end
