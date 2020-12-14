#property :policy_template, String, required: false, default: 'C:\Windows\security\templates\chefNewPolicy.inf'
#property :database, String, required: false, default: 'C:\Windows\security\database\chef.sdb'
#property :log_location, String, default: 'C:\Windows\security\logs\chef-secedit.log'
if node['platform'] == 'windows'
  template 'C:\Windows\security\templates\chefNewPolicy.inf' do
    source 'policy.inf.erb'
    cookbook 'windows-security-policy'
    action :create
  end

    execute 'Configure security database' do
      command "Secedit /configure /db C:\\Windows\\security\\database\\hardening.sdb /cfg C:\\Windows\\security\\templates\\chefNewPolicy.inf /log C:\\Windows\\security\\logs\\chef-secedit.log"
      live_stream true
      action :run
    end
else
    Chef::Log.info "This is for a Windows platform"
end
#end

if node['platform'] == 'windows'
  execute 'Export security database to inf file' do
    command "Secedit /configure /db C:\\Windows\\security\\database\\hardening.sdb /cfg C:\\Windows\\security\\templates\\chefNewPolicy.inf /log C:\\Windows\\security\\logs\\chef-secedit.log"
    live_stream true
    action :run
  end
else
  Chef::Log.info "It is only for a Windows platform"
end


if node['platform'] == 'windows'
  template 'C:\Windows\security\templates\chefNewPolicy.inf' do
    source 'policy.inf.erb'
    action :create
  end

  execute 'Import and create security database' do
    command "Secedit /configure /db C:\\Windows\\security\\database\\hardening.sdb /cfg C:\\Windows\\security\\templates\\chefNewPolicy.inf /log C:\\Windows\\security\\logs\\chef-secedit.log"
    live_stream true
    action :run
  end
else
  Chef::Log.info "It is only for a Windows platform"
end

