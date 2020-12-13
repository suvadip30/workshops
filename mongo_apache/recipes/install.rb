##########################################################################
# Cookbook Name:: mongodb
# Recipe:: install
#
# Not sure how to get started?
#
# You could:
# 1.  copy the relevant commands from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/
# 2.  comment out everything
# 3.  add the Chef resources and other Chef code necessary
#
# This file is an example of steps 1 and 2 above.
##########################################################################
#

# Create a /etc/yum.repos.d/mongodb.repo file to hold the following configuration information for the MongoDB repository:
#
# If you are running a 64-bit system, use the following configuration:
#
# [mongodb]
# name=MongoDB Repository
# baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
# gpgcheck=0
# enabled=1
# If you are running a 32-bit system, which is not recommended for production deployments, use the following configuration:
#
# [mongodb]
# name=MongoDB Repository
# baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/i686/
# gpgcheck=0
# enabled=1
#
# Install the MongoDB packages and associated tools.
#
# sudo yum install mongodb-org
#
#
# Start MongoDB.
#
# sudo service mongod start
#
# ensure that MongoDB will start following a system reboot by issuing the following command:
#
# sudo chkconfig mongod on#
#
case node['platform']
  when 'rhel', 'amazon', 'fedora'
    puts '************RHEL'
    case node['kernel']['machine']
      when "x86_64"
        puts "This is RHEL 64 bit"

        # Create Mongo-DB repo
        cookbook_file '/etc/yum.repos.d/mongodb.repo' do
          source 'mongodb_64.repo'
          mode '0755'
          action :create
        end

        # Install the MongoDB packages
        yum_package 'mongodb-org'
      
        # Start MongoDB
         service 'mongod' do
          supports :status => true, :restart => true, :reload => true
          action [ :enable, :start ]
        end
      when "i686"
        puts "This is RHEL 32 bit"

        # Create Mongo-DB repo
        cookbook_file '/etc/yum.repos.d/mongodb.repo' do
          source 'mongodb_32.repo'
          mode '0755'
          action :create
        end
     
        # Install the MongoDB packages
        yum_package 'mongodb-org'

        # Start MongoDB
        service 'mongod' do
          supports :status => true, :restart => true, :reload => true 
          action [ :enable, :start ]
        end
      end
  when 'ubuntu'
    puts '********************---------------ubuntu'

    # Import the public GPG key for MongoDB
    execute "" do
      command "curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -"
      action :run
    end

    # Create Ubuntu list file
    file "/etc/apt/sources.list.d/mongodb-org-4.4.list" do
      content "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse"
      mode "0644"
      owner "root"
      group "root"
      action :create
    end
    
    # Update apt
    apt_update "Update the apt" do
      frequency 86400
      action :periodic
    end

    # Install the MongoDB packages
    package 'mongodb-org'
    
    # Start MongoDB
    service 'mongod' do
      supports :status => true, :restart => true, :reload => true
      action [ :enable, :start ]
    end
  end
