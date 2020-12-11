#
# Cookbook:: mongo_apache
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'mongo_apache::install'
include_recipe 'mongo_apache::tomcat_install'
