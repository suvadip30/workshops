#
# Cookbook:: windows_remediate
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#
include_recipe 'windows_remediate::security_policy'
include_recipe 'windows_remediate::accounts'
include_recipe 'windows_remediate::interactive'
include_recipe 'windows_remediate::ntp_client'
include_recipe 'windows_remediate::ntp_server'
