require_relative 'spec_helper'
require_relative '../libraries/network'

describe "ktc-utils::Network" do
  let(:node) { Chef::Node.new }
  it 'should handle empty interface mappings' do
    KTC::Network.node = node
    KTC::Network.if_lookup('test').should == nil
  end

  it 'should lookup the right interface' do
    node.set['interface_mapping'] = { 'test' => 'eth0', 'test2' => 'eth1' }
    KTC::Network.node = node
    KTC::Network.if_lookup('test').should == 'eth0'
  end
end
