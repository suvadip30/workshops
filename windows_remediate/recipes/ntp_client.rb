# Enable Windows NTP Client
# # Default Value - Enable

registry_key 'HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\W32time\\TimeProviders\\NtpClient' do
  values [{
     name: 'Enabled',
     type: :dword,
     data: 1
   }]
   action :create
   recursive true
end
