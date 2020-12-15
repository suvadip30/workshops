#
# Cookbook Name:: mongodb
# Recipe:: install

case node['platform']
  when 'rhel', 'amazon', 'fedora'
    puts 'This is RHEL'
    case node['kernel']['machine']
      when "x86_64"
        puts "This is RHEL 64 bit"

        # Create Mongo-DB repo
        cookbook_file "#{node['mongo_apache']['yum_repo'] }/#{node['mongo_apache']['database']}.repo" do
          source "#{node['mongo_apache']['database']}_64.repo"
          mode '0755'
          action :create
        end

        # Install the MongoDB packages
        yum_package "#{node['mongo_apache']['database']}-org"
      
        # Start MongoDB
         service 'mongod' do
          supports :status => true, :restart => true, :reload => true
          action [ :enable, :start ]
        end
      when "i686"
        puts "This is RHEL 32 bit"

        # Create Mongo-DB repo
        cookbook_file "#{node['mongo_apache']['yum_repo'] }/#{node['mongo_apache']['database']}.repo" do
          source "#{node['mongo_apache']['database']}_32.repo"
          mode '0755'
          action :create
        end
     
        # Install the MongoDB packages
        yum_package "#{node['mongo_apache']['database']}-org"

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
    file "#{node['mongo_apache']['apt_repo']}/#{node['mongo_apache']['database']}-org-4.4.list" do
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
    package "#{node['mongo_apache']['database']}-org"
    
    # Start MongoDB
    service 'mongod' do
      supports :status => true, :restart => true, :reload => true
      action [ :enable, :start ]
    end
  end
