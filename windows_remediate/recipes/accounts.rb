node['account_status']['names'].each do |name|
execute "Execute #{name} account" do
  command "net user #{name} /active:#{node['account_status']['active_yes_no']}"
  action :run
  #not_if { ::File.exist?("C:\\#{node['account_status']['names']}_active_#{node['account_status']['active_yes_no']}.lock") }
  #notifies :create, "file[C:\\#{node['account_status']['names']}_active_#{node['account_status']['active_yes_no']}.lock]", :immediately
end
end
