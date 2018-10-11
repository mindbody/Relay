build_configurations = [
	{
		:scheme => "Relay-iOS",
		:run_tests => true,
		:destinations => [
			"OS=9.3,name=iPhone 5S",
			"OS=12.0,name=iPhone XS Max"
		]
	},
	{
		:scheme => "Relay-macOS",
		:run_tests => true,
		:destinations => [
			"platform=OS X,arch=x86_64"
		]
	},
	{
		:scheme => "Relay-tvOS",
		:run_tests => true,
		:destinations => [
			"OS=9.2,name=Apple TV 1080p",
			"OS=12.0,name=Apple TV 4K"
		]
	},
	{
		:scheme => "Relay-watchOS",
		:run_tests => false,
		:destinations => [
			"OS=latest,name=Apple Watch - 42mm"
		]
	}
]

desc "Pre-boot test simulators"
task :boot_simulators do
	simulator_prefixes = [
		"iPhone XS Max (12.0) [",
		"iPhone 5S (9.3) [",
		"Apple TV 1080p (9.2) [",
		"Apple TV 4K (at 1080p) (12.0) ["
	]
	simulator_prefixes.each do |prefix|
		execute "xcrun instruments -w '#{prefix}' || true"
	end
end

desc "Build all targets"
task :build do
  build_configurations.each do |config|
    scheme = config[:scheme]
    destinations = config[:destinations].map { |destination| "-destination '#{destination}'" }.join(" ")
    execute "xcodebuild -project Relay.xcodeproj -scheme #{scheme} #{destinations} -configuration Debug -quiet build analyze"
  end
end

desc "Run all unit tests on all platforms"
task :test do
  execute "swift test --parallel"
  build_configurations.each do |config|
    scheme = config[:scheme]
    destinations = config[:destinations].map { |destination| "-destination '#{destination}'" }.join(" ")

    if config[:run_tests] then
      execute "set -o pipefail && xcodebuild -project Relay.xcodeproj -scheme #{scheme} #{destinations} -configuration Debug -quiet build-for-testing analyze"
      execute "set -o pipefail && xcodebuild -project Relay.xcodeproj -scheme #{scheme} #{destinations} -configuration Debug -quiet test-without-building"
    else
      execute "set -o pipefail && xcodebuild -project Relay.xcodeproj -scheme #{scheme} #{destinations} -configuration Debug -quiet build analyze"
    end
  end
end

desc "Clean all builds"
task :clean do
  `swift package reset`
  build_configurations.each do |config|
    scheme = config[:scheme]
    execute "set -o pipefail && xcodebuild -project Relay.xcodeproj -scheme #{scheme} -configuration Debug -quiet clean"
  end
end

def execute(command)
  puts "\n\e[36m======== EXECUTE: #{command} ========\e[39m\n"
  system("set -o pipefail && #{command}") || exit(-1)
end
