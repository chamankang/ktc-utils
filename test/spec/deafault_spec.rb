require 'chefspec'

describe 'ktc-utils::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'ktc-utils::default' }
  it 'does something' do
  end
end
