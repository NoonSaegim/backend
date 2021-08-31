#
# Generated file, do not edit.
#

Pod::Spec.new do |s|
  s.name             = 'FlutterPluginRegistrant'
  s.version          = '0.0.1'
  s.summary          = 'Registers plugins with your flutter app'
  s.description      = <<-DESC
Depends on all your plugins, and provides a function to register them.
                       DESC
  s.homepage         = 'https://flutter.dev'
  s.license          = { :type => 'BSD' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.ios.deployment_target = '9.0'
  s.source_files =  "Classes", "Classes/**/*.{h,m}"
  s.source           = { :path => '.' }
  s.public_header_files = './Classes/**/*.h'
  s.static_framework    = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.dependency 'Flutter'
  s.dependency 'audio_service'
  s.dependency 'audio_session'
  s.dependency 'camera'
  s.dependency 'flutter_email_sender'
  s.dependency 'flutter_isolate'
  s.dependency 'flutter_keyboard_visibility'
  s.dependency 'flutter_sound'
  s.dependency 'flutter_tts'
  s.dependency 'hexcolor'
  s.dependency 'image_cropper'
  s.dependency 'image_picker'
  s.dependency 'package_info_plus'
  s.dependency 'path_provider'
  s.dependency 'permission_handler'
  s.dependency 'shared_preferences'
  s.dependency 'sqflite'
end