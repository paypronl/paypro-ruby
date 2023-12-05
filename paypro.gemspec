# frozen_string_literal: true

require File.expand_path('lib/pay_pro/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'paypro'
  s.version = PayPro::VERSION
  s.author = 'PayPro'
  s.email = ['support@paypro.nl']

  s.summary = 'Ruby library for the PayPro API'
  s.description = 'Online payments for entrepreneurs that want maximum growth'
  s.homepage = 'https://www.paypro.nl'
  s.license = 'MIT'
  s.required_ruby_version = Gem::Requirement.new('>= 3.0.0')

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/paypronl/paypro-ruby'
  s.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  s.add_dependency 'faraday', '>= 1.10'

  s.require_paths = ['lib']
end
