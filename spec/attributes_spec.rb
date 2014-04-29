require_relative 'spec_helper'
require_relative '../libraries/attributes'
require 'services'

describe 'ktc-utils::Attributes' do
  let(:service) do
    {
      service: 'utils-test-service',
      port: 55_555,
      proto: 'xxx',
      ip: '127.0.0.1'
    }
  end

  before do
    ChefSpec::Runner.new.converge 'etcd::compile_time'
    Services::Connection.new host: '127.0.0.1'
    utils_test_service = Services::Member.new 'localhost.localdomain', service
    utils_test_service.save

  end
  context 'get_endpoint' do

    it 'should lookup the right service' do
      utils_test_service = Services::Service.new 'utils-test-service'
      ha_disabled = true
      KTC::Attributes.get_endpoint(utils_test_service, ha_disabled).should ==
        [service['ip'], service['port']]
    end
  end
end
