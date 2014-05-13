source  'https://rubygems.org'

# get this from git for the chefignore issues
gem 'berkshelf'

group 'develop' do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-openstack'
  gem 'rake'
  # https://github.com/acrmp/foodcritic/pull/190
  # and fixes the nokogiri conflict
  gem 'foodcritic',
      git: 'https://github.com/spheromak/foodcritic.git',
      branch: 'works_with_openstack'
  gem 'rubocop'
  gem 'knife-cookbook-doc'
  gem 'chefspec', '>= 3.2.0'
  gem 'git'
  gem 'jn_services', '= 1.0.7'
  gem 'etcd', '= 0.2.1'
end
