
# PSCityPickerView
城市选择器，可以选择国内所有的城市和地区.继承与系统原生控件UIPickerView.你可以像设置任何系统的PickerView一样自定义他的背景颜色等属性。


### 预览 
![image](https://raw.githubusercontent.com/DeveloperPans/PSCityPickerView/master/PSCityPickerView.gif)

### 导入

#####`推荐` 通过Cocoapods导入
在你的Podfile文件中加入如下一行

```ruby
pod 'PSCityPickerView'
```

##### 手动导入
下载zip并解压。将PSCityPickerView文件夹拖入你的Xcode工程中。


### 使用方法
**推荐使用懒加载初始化，并设置代理.**
 
```objective-c
@property (nonatomic, strong) PSCityPickerView *cityPicker;


- (PSCityPickerView *)cityPicker
{
    if (!_cityPicker)
    {
        _cityPicker = [[PSCityPickerView alloc] init];
        _cityPicker.cityPickerDelegate = self;
    }
    return _cityPicker;
}
 ```
 
**设置inputView为cityPicker.**

```objective-c
self.textField.inputView = self.cityPicker;

```

**代理中返回省、市、区信息.**

```objective-c
#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker
    finishPickProvince:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district
{
    [self.textField setText:[NSString stringWithFormat:@"%@ %@ %@",province,city,district]];
}

```


更多信息请查看源码。
