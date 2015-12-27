//
//  ViewController.m
//  PSCityPickerViewDemo
//
//  Created by Pan on 15/11/15.
//  Copyright © 2015年 Shengpan. All rights reserved.
//

#import "ViewController.h"

#import "PSCityPickerView.h"

@interface ViewController ()<PSCityPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) PSCityPickerView *cityPicker;

@end

@implementation ViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.inputView = self.cityPicker;
}

#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker
    finishPickProvince:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district
{
    [self.textField setText:[NSString stringWithFormat:@"%@ %@ %@",province,city,district]];
}

#pragma mark - Getter and Setter
- (PSCityPickerView *)cityPicker
{
    if (!_cityPicker)
    {
        _cityPicker = [[PSCityPickerView alloc] init];
        _cityPicker.cityPickerDelegate = self;
    }
    return _cityPicker;
}

@end
