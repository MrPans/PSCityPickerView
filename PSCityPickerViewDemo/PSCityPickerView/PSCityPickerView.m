//
//  PSCityPickerView.m
//  Diamond
//
//  Created by Pan on 15/8/12.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSCityPickerView.h"

#define PS_CITY_PICKER_COMPONENTS 3
#define PROVINCE_COMPONENT        0
#define CITY_COMPONENT            1
#define DISCTRCT_COMPONENT        2
#define FIRST_INDEX               0


#define COMPONENT_WIDTH 100 //每一列的宽度

@interface PSCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic, copy, readwrite) NSString *province;
@property (nonatomic, copy, readwrite) NSString *city;
@property (nonatomic, copy, readwrite) NSString *district;

@property (nonatomic, copy) NSDictionary *allCityInfo;
@property (nonatomic, copy) NSArray *provinceArr;/**< 省名称数组*/
@property (nonatomic, copy) NSArray *cityArr;/**< 市名称数组*/
@property (nonatomic, copy) NSArray *districtArr;/**< 区名称数组*/
@property (nonatomic, copy) NSDictionary *currentProvinceDic;
@property (nonatomic, copy) NSDictionary *currentCityDic;

@end

@implementation PSCityPickerView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    //包含3列
    return PS_CITY_PICKER_COMPONENTS;
}

//该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case PROVINCE_COMPONENT: return [self.provinceArr count];
        case CITY_COMPONENT:     return [self.cityArr count];
        case DISCTRCT_COMPONENT: return [self.districtArr count];
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel)
    {
        titleLabel = [self labelForPickerView];
    }
    titleLabel.text = [self titleForComponent:component row:row];
    return titleLabel;
}

//选择指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT)
    {
        NSDictionary *provinceDic = [self provinceDicAtIndex:row];
        NSArray *cityNames = [self cityNamesInProvinceDic:provinceDic];
        self.currentProvinceDic = provinceDic;
        self.cityArr = cityNames;
    
        NSDictionary *cityDic = [self provinceDic:provinceDic cityDicAtIndex:FIRST_INDEX];
        NSArray *districtNames = [self districtArrayInCityDic:cityDic];
        self.districtArr = districtNames;
        
        
        self.province = [self provinceNameWithPrivinceDic:provinceDic];
        self.city = [[self cityNamesInProvinceDic:provinceDic] firstObject];
        self.district = [self.districtArr firstObject];
        
        [pickerView selectRow:FIRST_INDEX inComponent:CITY_COMPONENT animated:YES];
        [pickerView selectRow:FIRST_INDEX inComponent:DISCTRCT_COMPONENT animated:YES];
        
        [pickerView reloadAllComponents];
    }
    else if (component == CITY_COMPONENT)
    {
        NSDictionary *cityDic = [self provinceDic:self.currentProvinceDic cityDicAtIndex:row];
        self.currentCityDic = cityDic;
        self.districtArr = [self districtArrayInCityDic:cityDic];
        
        self.province = [self provinceNameWithPrivinceDic:self.currentProvinceDic];
        self.city = [self cityNameWithCityDic:cityDic];
        self.district = [self.districtArr firstObject];
        
        [pickerView selectRow:FIRST_INDEX inComponent:DISCTRCT_COMPONENT animated:YES];
        [pickerView reloadComponent:DISCTRCT_COMPONENT];
    }
    else if (component == DISCTRCT_COMPONENT)
    {
        self.province = [self provinceNameWithPrivinceDic:self.currentProvinceDic];
        self.city = [self cityNameWithCityDic:self.currentCityDic];
        self.district = [self.districtArr objectAtIndex:row];
    }
    
    if ([self.cityPickerDelegate respondsToSelector:@selector(cityPickerView:finishPickProvince:city:district:)])
    {
        [self.cityPickerDelegate cityPickerView:self finishPickProvince:self.province city:self.city district:self.district];
    }
}

//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return COMPONENT_WIDTH;
}


#pragma mark - Private
- (UILabel *)labelForPickerView
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row;
{
    switch (component)
    {
        case PROVINCE_COMPONENT: return [self.provinceArr objectAtIndex:row];
        case CITY_COMPONENT:     return [self.cityArr objectAtIndex:row];
        case DISCTRCT_COMPONENT: return [self.districtArr objectAtIndex:row];
    }
    return @"";
}

/**
 *  获取省级字典
 *
 *  @param index
 *
 *  @return 省级字典
 */
- (NSDictionary *)provinceDicAtIndex:(NSUInteger)index;
{
    return [self.allCityInfo objectForKey:[@(index) stringValue]];
}

/**
 *  返回省级字典的名字
 *
 *  @param privinceDic 省级字典
 *
 *  @return NSString
 */
- (NSString *)provinceNameWithPrivinceDic:(NSDictionary *)provinceDic
{
    return [[provinceDic allKeys] firstObject];
}

/**
 *  返回省级字典下面的市名称列表
 *
 *  @param privinceDic 省级字典
 *
 *  @return NSArray<NSString>
 */
- (NSMutableArray *)cityNamesInProvinceDic:(NSDictionary *)provinceDic
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < [[[provinceDic allValues] firstObject] count]; i++)
    {
        NSDictionary *cityDic = [self provinceDic:provinceDic cityDicAtIndex:i];
        [temp addObject:[self cityNameWithCityDic:cityDic]];
    }
    return temp;
}


/**
 *  获取省级字典下的市级字典
 *
 *  @param privinceDic 省级字典
 *  @param index
 *
 *  @return 市级字典
 */
- (NSDictionary *)provinceDic:(NSDictionary *)provinceDic cityDicAtIndex:(NSUInteger)index;
{
    NSDictionary *cityDicInProvince = [provinceDic objectForKey:[self provinceNameWithPrivinceDic:provinceDic]];
    return [cityDicInProvince objectForKey:[@(index) stringValue]];
}

/**
 *  返回市级字典的市名称
 *
 *  @param cityDic 市级字典
 *
 *  @return NSSting
 */
- (NSString *)cityNameWithCityDic:(NSDictionary *)cityDic
{
    return [[cityDic allKeys] firstObject];
}

/**
 *  返回市级字典下的区/县信息
 *
 *  @param cityDic 市级字典
 *
 *  @return NSArray<NSString>
 */
- (NSArray *)districtArrayInCityDic:(NSDictionary *)cityDic
{
    return [[cityDic allValues] firstObject];
}

#pragma mark - Getter and Setter

- (NSDictionary *)allCityInfo
{
    if (!_allCityInfo)
    {
        NSBundle *bundle=[NSBundle mainBundle];
        NSString *path=[bundle pathForResource:@"city" ofType:@"plist"];
        _allCityInfo = [[NSDictionary alloc]initWithContentsOfFile:path];
    }
    return _allCityInfo;
}

- (NSArray *)provinceArr
{
    if (!_provinceArr)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSInteger i = 0 ; i < [[self.allCityInfo allKeys] count]; i++)
        {
            NSDictionary *provinceDic = [self provinceDicAtIndex:i];
            [temp addObject:[self provinceNameWithPrivinceDic:provinceDic]];
        }
        _provinceArr = temp;
    }
    return _provinceArr;
}

- (NSArray *)cityArr
{
    if (!_cityArr)
    {
        NSDictionary *provinceDic = [self provinceDicAtIndex:FIRST_INDEX];
        _cityArr = [self cityNamesInProvinceDic:provinceDic];
    }
    return _cityArr;
}

- (NSArray *)districtArr
{
    if (!_districtArr)
    {
        NSDictionary *cityDic = [self provinceDic:[self provinceDicAtIndex:FIRST_INDEX] cityDicAtIndex:FIRST_INDEX];
        _districtArr = [self districtArrayInCityDic:cityDic];
    }
    return _districtArr;
}

- (NSDictionary *)currentProvinceDic
{
    if (!_currentProvinceDic) {
        _currentProvinceDic = [self provinceDicAtIndex:FIRST_INDEX];
    }
    return _currentProvinceDic;
}

- (NSDictionary *)currentCityDic
{
    if (!_currentCityDic) {
        _currentCityDic = [self provinceDic:self.currentProvinceDic cityDicAtIndex:FIRST_INDEX];
    }
    return _currentCityDic;
}

@end
