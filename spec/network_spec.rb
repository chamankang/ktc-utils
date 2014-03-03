require_relative 'spec_helper'
require_relative '../libraries/network'

describe 'ktc-utils::Network' do
  let(:node) { Chef::Node.new }
  before do
    node.set[:network][:interfaces]['eth0'] = {
      'type' => 'eth',
      'number' => '0',
      'mtu' => '1500',
      'flags' => %w/
        BROADCAST
        MULTICAST
        UP
        LOWER_UP
      /,
      'encapsulation' => 'Ethernet',
      'addresses' => {
        '52:54:00:44:56:02' => {
          'family' => 'lladdr'
        },
        '10.9.241.47' => {
          'family' => 'inet',
          'prefixlen' => '24',
          'netmask' => '255.255.255.0',
          'broadcast' => '10.9.241.255',
          'scope' => 'Global'
        },
        'fe80::5054:ff:fe44:5602' => {
          'family' => 'inet6',
          'prefixlen' => '64',
          'scope' => 'Link'
        }
      },
      'state' => 'up',
      'arp' => {
        '10.9.241.30' => 'b6:f8:ec:e3:a2:63',
        '10.9.241.46' => '52:54:00:44:56:01',
        '10.9.241.89' => '52:54:00:44:67:01',
        '10.9.241.92' => '52:54:00:44:68:01',
        '10.9.241.48' => '52:54:00:44:56:03',
        '10.9.241.31' => '32:4f:e3:0d:92:11',
        '10.9.241.1' => '00:00:0c:07:ac:11',
        '10.9.241.77' => '52:54:00:44:63:01'
      },
      'routes' => [
        {
          'destination' => 'default',
          'family' => 'inet',
          'via' => '10.9.241.1',
          'metric' => '100'
        },
        {
          'destination' => '10.9.241.0/24',
          'family' => 'inet',
          'scope' => 'link',
          'proto' => 'kernel',
          'src' => '10.9.241.47'
        },
        {
          'destination' => 'fe80::/64',
          'family' => 'inet6',
          'metric' => '256',
          'proto' => 'kernel'
        }
      ]
    }
    KTC::Network.node = node
  end
  context 'if_lookup' do

    it 'should handle empty interface mappings' do
      KTC::Network.if_lookup('test').should.nil?
    end

    it 'should lookup the right interface' do
      node.set['interface_mapping'] = { 'test' => 'eth0', 'test2' => 'eth1' }
      KTC::Network.if_lookup('test').should == 'eth0'
    end
  end

  context 'address' do
    it 'should handle missing interface' do
      KTC::Network.address('xxxxxxx').should.nil?
    end

    it 'should get the ipaddr of the interface' do
      KTC::Network.address('eth0').should == '10.9.241.47'
    end
  end
end
