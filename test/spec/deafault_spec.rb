require 'chefspec'

describe 'ktc-utils::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'ktc-utils::default' }
  it 'does something' do
    pending 'Your recipe examples go here.'
  end
end
