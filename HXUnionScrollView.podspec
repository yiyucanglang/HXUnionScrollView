Pod::Spec.new do |s|
  s.name             = 'HXUnionScrollView'
  s.version          = '1.0.7'
  s.summary          = '联动滑动悬停控件'

  s.homepage         = 'https://github.com/yiyucanglang'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dahuanxiong' => 'xinlixuezyj@163.com' }
  s.source           = { :git => 'https://github.com/yiyucanglang/HXUnionScrollView.git', :tag => s.version }
  
  s.ios.deployment_target = '8.0'
  s.static_framework = true
  
  s.dependency 'Masonry'
  s.dependency 'HXConvenientListView/Core'
  s.public_header_files = '*{h}'
  s.source_files = '*.{h,m}'
  
 end
