$concurrent_destinations = 1
$framework = "Relay"

def build_matrix
  return [
    {
      :scheme => "#{$framework}-iOS",
      :run_tests => true,
      :destinations => [
        "OS=latest,name=iPad Air 2"
      ]
    },
    {
      :scheme => "#{$framework}-macOS",
      :run_tests => true,
      :destinations => [
        "platform=OS X,arch=x86_64"
      ]
    },
    {
      :scheme => "#{$framework}-tvOS",
      :run_tests => true,
      :destinations => [
        "OS=latest,name=Apple TV 4K"
      ]
    },
    {
      :scheme => "#{$framework}-watchOS",
      :run_tests => false,
      :destinations => [
        "OS=latest,name=Apple Watch Series 5 - 40mm"
      ]
    }
  ]
end

desc "Clean all builds"
task :clean do
  clean_all_schemes
end

desc "Update project dependencies"
task :update do
  update_dependencies
end

desc "Build all targets"
task :build do
  build_all_schemes
end

desc "Run all tests"
task :test do
  test_all_schemes
end

desc "Run all tests on SPM"
task :test_spm do
  test_spm
end

desc "Run all iOS tests"
task :test_ios do
  test_platform build_matrix.find { |config| config[:scheme] == "#{$framework}-iOS" }
end

desc "Run all macOS tests"
task :test_macos do
  test_platform build_matrix.find { |config| config[:scheme] == "#{$framework}-macOS" }
end

desc "Run all tvOS tests"
task :test_tvos do
  test_platform build_matrix.find { |config| config[:scheme] == "#{$framework}-tvOS" }
end

desc "Run all watchOS tests"
task :test_watchos do
  test_platform build_matrix.find { |config| config[:scheme] == "#{$framework}-watchOS" }
end

desc "Install CI dependencies"
task :ci_install do
  system("bundle install")
  system("bundle exec danger")
end


#
#  Utility functions for rake tasks. Can be overriden.
#

def clean_all_schemes
  execute "swift package reset" if swift_package_manager
  build_matrix.each do |config|
    scheme =  config[:scheme]
    execute "xcodebuild -scheme #{scheme} -quiet clean"
  end
end

def build_all_schemes
  execute "swift build" if swift_package_manager
  build_matrix.each do |config|
    scheme =  config[:scheme]
    destinations = config[:destinations].map { |destination| "-destination '#{destination}'" }.join(" ")
    execute "xcodebuild -scheme #{scheme} -configuration Release #{destinations} -quiet build analyze"
  end
end

def test_all_schemes
  test_spm if swift_package_manager
  build_matrix.each do |config|
    test_platform config
  end
end

def test_spm
  execute "swift test --parallel"
end

def test_platform(config)
  scheme =  config[:scheme]
  destinations = config[:destinations].map { |destination| "-destination '#{destination}'" }.join(" ")
  if config[:run_tests] then
    execute "xcodebuild -scheme #{scheme} #{destinations} -quiet build-for-testing analyze"
    execute "xcodebuild -scheme #{scheme} #{destinations} -quiet -disable-concurrent-destination-testing test-without-building"
  else
    execute "xcodebuild -scheme #{scheme} -configuration Release #{destinations} -quiet build analyze"
  end
end

def swift_package_manager
  return File.file?("Package.swift")
end

def bootstrap
  execute "carthage bootstrap --cache-builds"
end

def update_dependencies
  execute "carthage update --cache-builds"
  execute "swift package update" if swift_package_manager
end

def execute(command)
  puts "\n\e[35m=== EXECUTE: #{command} ===\e[39m\n\n"
  system(command) || fail_build
  puts "\n\e[32m=== EXECUTE: Command exited with code 0. ===\e[39m\n\n"
end

def fail_build
  puts "\n\e[101m=== EXECUTE: Command failed. ===\e[39m\e[49m\n\n"
  exit -1
end
