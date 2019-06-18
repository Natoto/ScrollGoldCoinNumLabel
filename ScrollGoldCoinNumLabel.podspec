Pod::Spec.new do |s|
    s.name         = 'ScrollGoldCoinNumLabel'
    s.version      = '0.0.1'
    s.summary      = '金币数字上下滚动的label'
    s.homepage     = 'https://www.yy.com'
    s.authors  = { 'natoto' => '787038442@qq.com' }
    s.license =  { :type => 'BSD' }
    
    s.source   = { :path => 'src/' }
    s.requires_arc = true
    s.platform     = :ios, '8.0'
    s.public_header_files = 'src/**/*.h'
   
end
