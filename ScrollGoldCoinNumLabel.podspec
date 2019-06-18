Pod::Spec.new do |s|
    s.name         = 'ScrollGoldCoinNumLabel'
    s.version      = '0.0.1'
    s.summary      = '金币数字上下滚动的label' 
    s.homepage     = "https://github.com/Natoto/ScrollGoldCoinNumLabel.git"
    s.license      = "MIT"
    s.authors      = { 'natoto ' => '787486160@qq.com'}
    s.platform     = :ios,'7.0'
    s.source       = { :git => "https://github.com/Natoto/ScrollGoldCoinNumLabel.git", :tag => s.version }
    s.source_files = "Class/**/*.{h,m}" 
    s.requires_arc = true 
   
end
