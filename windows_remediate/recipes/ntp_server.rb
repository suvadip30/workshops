# Enable Windows NTP Server
# # Default Value - Disable

registry_key 'HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\W32time\\TimeProviders\\NtpServer' do
  values [{
     name: 'Enabled',
     type: :dword,
     data: 0
   }]
   action :create
   recursive true
end
