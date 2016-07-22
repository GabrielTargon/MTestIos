platform :ios, '8.0'
use_frameworks!

pod 'Groot'
pod 'RestKit', '~> 0.27'

post_install do |installer|
    `find Pods -regex 'Pods/Groot.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)Groot\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end