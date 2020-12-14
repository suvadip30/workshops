# Interactive logon: Do not require CTRL+ALT+DEL
# Default value - Disable

registry_key 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' do
  values [{
  name: 'DisableCAD',
  type: :dword,
  data: 0
  }]
  action :create
  recursive true
end
