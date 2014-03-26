# Encoding: UTF-8
# sane default
# Just force everything to eth0
# Every env attrib file should override
default['interface_mapping']['disk'] = 'eth0'
default['interface_mapping']['private'] = 'eth0'
default['interface_mapping']['public'] = 'eth0'
default['interface_mapping']['management'] = 'eth0'

default['service_names'] = %w(
  compute block-storage dashboard identity image metering network volume
)
