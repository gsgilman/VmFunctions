lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'VmFunctions'
  s.version     = '0.0.0'
  s.date        = '2014-06-20'
  s.description = 'Basic functions for scripting vm tasks'
  s.summary     = 'For use with vmware'
  s.authors     = ['Graham Gilman']
  s.email       = 'graham.sgilman@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    =
      'http://github.com/gsgilman/VmFunctions'
  s.license     = 'MIT'
  s.require_paths = ["lib"]
  s.add_runtime_dependency "nokogiri", "= 1.5.5"
  s.add_runtime_dependency "rbvmomi", "= 1.5.1"
  s.add_runtime_dependency "waitutil"

end
