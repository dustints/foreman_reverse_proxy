# Tasks
namespace :foreman_reverse_proxy do
  desc "Runs Rubocop style checker on Katello code"
  task :rubocop do
    system("cd #{ForemanReverseProxy::Engine.root} && bundle exec rubocop")
  end

  desc "Runs Rubocop style checker with xml output for Jenkins"
  task 'rubocop:jenkins' do
    system("cd #{ForemanReverseProxy::Engine.root} && bundle exec rubocop \
            --require rubocop/formatter/checkstyle_formatter \
            --format RuboCop::Formatter::CheckstyleFormatter \
            --no-color --out rubocop.xml")
    exit($?.exitstatus)
  end
end
