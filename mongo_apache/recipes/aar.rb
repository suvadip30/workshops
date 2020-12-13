cookbook_file '/tmp/AARinstall.py' do
  action :create
end

# Update apt
apt_update "Update the apt" do
  frequency 86400
  action :periodic
end

# Install Apache2
apt_package "apache2" do
  action :install
end

# Create database queries
cookbook_file '/tmp/mysql_secure_installation.sql' do
  action :create
end

# Install mysql
#apt_package "mysql-server" do
#  action :install
#end

execute "Install mysql passwordless" do
  command <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    sudo -E apt-get -q -y install mysql-server
    mysql -u root < /tmp/mysql_secure_installation.sql
  EOF
  action :run
end

# Install unzip
apt_package "unzip" do
   action :install
end

# Execute sql secure installation
#execute "Mysql Secure Installation" do
#  command "mysql_secure_installation"
#  action :run
#end

# Download Awesome Appliance
remote_file "/tmp/master.zip" do
  source "https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# Untar Awesome Appliance Installer
execute "Unzip Awesome Appliance Installer" do
  command "unzip /tmp/master.zip"
  action :run
  not_if { ::File.exist?('/tmp/master.zip')}
end

# Start and Enable service
service "apache2" do
   supports :status => true, :restart => true, :reload => true
   action [ :enable, :start ]
end

# Move AAR to www directory
execute "Move AAR directory" do
  command <<-EOF
    cd Awesome-Appliance-Repair-master/
    mv AAR /var/www/
    python AARinstall.py
  EOF
  action :run
end

# Start and Enable service
service "apache2" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Execute Apachectl graceful
execute "Execute Apachectl graceful" do
  command "apachectl graceful"
  action :run
end
