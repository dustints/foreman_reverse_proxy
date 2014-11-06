require File.expand_path('../lib/foreman_reverse_proxy/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "foreman_reverse_proxy"
  s.version     = ForemanReverseProxy::VERSION
  s.date        = Date.today.to_s
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ForemanReverseProxy."
  s.description = "TODO: Description of ForemanReverseProxy."

  s.files = Dir["{app,config,db,lib}/**/*"] +
    ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "deface"
  s.add_development_dependency "rubocop", "0.24.1"
  s.add_development_dependency "rubocop-checkstyle_formatter"
  #s.add_development_dependency "sqlite3"
end
