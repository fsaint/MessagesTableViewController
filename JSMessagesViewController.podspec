Pod::Spec.new do |s|
  s.name         = "JSMessagesViewController"
  s.version      = "1.1.0b-bcontext"
  s.summary      = "A messages UI for iPhone and iPad. With Avatars."
  s.description  = "This messages tableview controller is very similar to the one in the iOS Messages app. Note, this is only a messaging UI, not a messaging app. This is intended to be used in an existing app where you have (or are developing) a messaging system and need a user interface for it."
  s.homepage     = "https://github.com/fsaint/MessagesTableViewController"
  s.license      = 'MIT License'
  s.author       = { "Jesse Squires" => "jesse.d.squires@gmail.com" }
  s.source       = { :git => "https://github.com/fsaint/MessagesTableViewController.git", :tag => s.version.to_s }
  s.platform     = :ios, '5.0'
  s.source_files = 'JSMessagesTableViewController'
  s.resources    = "JSMessagesTableViewController/Resources/**/*.*"
  s.frameworks   = 'AudioToolbox'
  s.requires_arc = true
  s.dependency 'JGAFImageCache'
end
