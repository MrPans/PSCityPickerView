Pod::Spec.new do |s|

  s.name         = "PSCityPickerView"
  s.version      = "1.0.0"
  s.summary      = "A convenience picker include all provinces,cities and districts in China."
  s.description  = <<-DESC
                  A convenience picker include all provinces,cities and districts in China. 
                  A convenience picker include all provinces,cities and districts in China.
                   DESC
  s.homepage     = "https://github.com/DeveloperPans/PSCityPickerView"
  s.screenshots  = "https://raw.githubusercontent.com/DeveloperPans/PSCityPickerView/master/PSCityPickerView.gif"
  s.license      = "MIT"
  s.author             = { "Pan" => "developerpans@163.com" }
  s.social_media_url = 'http://shengpan.net'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/DeveloperPans/PSCityPickerView.git", :tag => s.version.to_s }
  s.source_files = 'PSCityPickerViewDemo/PSCityPickerView/**/*.{h,m}'
  s.resource = "PSCityPickerViewDemo/PSCityPickerView/*.plist"

end
