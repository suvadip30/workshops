#include_recipe 'build-essential'

# Update apt-get
apt_update "Update the apt" do
   frequency 86400
   action :periodic
end

# Install Ruby
include_recipe 'mongo_apache::ruby'

# Install Apache2
apt_package "apache2" do
  action :install
end

# Configure Apache
execute "Configure Apache" do
  command <<-EOF
    a2enmod proxy_http
    a2enmod rewrite
  EOF
  action :run
end

# Create blog file
cookbook_file '/etc/apache2/sites-enabled/blog.conf' do
  action :create
end

# Remove file
file '/etc/apache2/sites-enabled/000-default.conf' do
  action :delete
  only_if { File.exist? '/etc/apache2/sites-enabled/000-default.conf' }
end

# Start and Enable apache service
service "apache2" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Install Git
apt_package "git" do
  action :install
end

# Clone git repository
execute "Clone Middleman-blog git repository" do
  cwd "/etc"
  command "git clone https://github.com/learnchef/middleman-blog.git"
  not_if { ::File.directory?('/etc/middleman-blog')}
end

# Install Bundler
gem_package "bundler" do
  #version '1.15.4'
  action :install
end

# Project dependencies
user "b_user" do
  home "/home/b_user"
  group "sudo"
  system true
end

execute "Permission to /home/ubuntu" do
  command "chown b_user:ubuntu /home/ubuntu"
end

execute "Permission to /home/ubuntu" do
 command "chmod 755 /root"
end

# Create home directory
directory "/home/b_user" do
  owner "b_user"
end

execute "Bundler Installation" do
  cwd "/etc/middleman-blog"
  command <<-EOH
    bundle clean --force
    bundle update
    bundle install
  EOH
  user "b_user"
end
# Install thin service
#template "/etc/init.d/thin" do
#  source "thin.erb"
#end

#execute "Install thin" do
#  command "/usr/sbin/update-rc.d -f thin defaults"
#  action :run
#end

#template "/etc/thin/blog.yml" do
#    source "blog.yml.erb"
#end

# Start and Enable thin service
#service "thin" do
#  supports :status => true, :restart => true, :reload => true
#  action [ :enable, :start ]
#end

#service "thin" do
#  action :restart
#end
