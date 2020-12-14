apt_update "Update the apt" do
  frequency 86400
  action :periodic
end
# Install packages
%w{ build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3 }.each do |pack|
  package pack
end

# Build Ruby
directory "/tmp/ruby" do
  action :create
end

# Download Ruby
remote_file "/tmp/ruby/ruby-#{node['ruby']['version']}.#{node['ruby']['patch']}.tar.gz" do
  source "http://cache.ruby-lang.org/pub/ruby/#{node['ruby']['version']}/ruby-#{node['ruby']['version']}.#{node['ruby']['patch']}.tar.gz"
  action :create
end

# Untar Ruby package
  execute "Untar Ruby Installer" do
    command "tar -xzf /tmp/ruby/ruby-#{node['ruby']['version']}.#{node['ruby']['patch']}.tar.gz -C /tmp/ruby"
  action :run
  not_if { ::File.exist?("/tmp/ruby/ruby-#{node['ruby']['version']}.#{node['ruby']['patch']}")}
end

# Install Ruby package
bash "Execute ruby command" do
  cwd ::File.dirname("/tmp/ruby/ruby-#{node['ruby']['version']}.#{node['ruby']['patch']}/configure")
  code <<-EOF
    sudo ./configure
    sudo make install
    sudo cp /usr/local/bin/ruby /usr/bin/ruby
    sudo cp /usr/local/bin/gem /usr/bin/gem
  EOF
  not_if { ::File.exist?('/usr/bin/gem') }
end

directory "/tmp/ruby" do
  recursive true
  action :delete
end
