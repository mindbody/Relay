$version = '0.2.1'

Pod::Spec.new do |spec|
	spec.name = 'Relay'
	spec.version = $version
	spec.license = { :type => 'MIT', :file => 'LICENSE' }
	spec.homepage = 'https://github.com/mindbody/Relay'
	spec.author = 'Relay Contributors'
	spec.summary = 'Swift Dynamic Dependency Injection for modern testing'
	spec.source = { :git => 'https://github.com/mindbody/Relay.git', :tag => $version }
	spec.source_files = 'Sources/**/*.swift'
	spec.ios.deployment_target = '8.0'
	spec.watchos.deployment_target = '2.0'
	spec.tvos.deployment_target = '9.0'
	spec.osx.deployment_target = '10.10'
end
