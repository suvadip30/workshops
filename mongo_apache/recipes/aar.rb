#cookbook_file '/tmp/AARinstall.py' do
#  action :create
#end

# Update apt
apt_update "Update the apt" do
  frequency 86400
  action :periodic
end

# Install Apache2
apt_package "apache2" do
  action :install
end

#Install Python 2.7
apt_package "python" do
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
  command "unzip /tmp/master.zip -d /tmp"
  action :run
  not_if { ::File.exist?('/tmp/Awesome-Appliance-Repair-master')}
end

# Start and Enable service
service "apache2" do
   supports :status => true, :restart => true, :reload => true
   action [ :enable, :start ]
end

template "/tmp/Awesome-Appliance-Repair-master/AARinstall.py" do
  source "AARinstall.py.erb"
end
# Move AAR to www directory
execute "Move AAR directory" do
  command <<-EOF
    cd /tmp/Awesome-Appliance-Repair-master/
    mv AAR /var/www/
  EOF
  action :run
  not_if { ::File.exist?('/var/www/AAR')}
end

# Execute AARinstall
execute "Execute AARinstall" do
  command <<-EOF
    cd /tmp/Awesome-Appliance-Repair-master/
    python AARinstall.py
  EOF
  action :run
#  not_if  "mysql -u root -e \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'AARdb'\""
  not_if "mysql -u root -e \"select table_name from information_schema.tables where table_schema = 'AARdb'\" | grep customer"
end
#template "/etc/apache2/sites-available/aar.conf" do
#    source "aar.conf.erb"
#end

#link "/etc/apache2/sites-enabled/aar.conf" do
#  to "/etc/apache2/sites-available/aar.conf"
#  notifies :restart, "service[apache2]"
#end

#link "/etc/apache2/sites-enabled/000-default.conf" do
#  to "/etc/apache2/sites-available/000-default.conf"
#  action :delete
#  notifies :restart, "service[apache2]"
#end

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
