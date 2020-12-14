describe security_policy do
      its('SeRemoteInteractiveLogonRight') { should eq ['S-1-5-32-544', 'S-1-5-32-555'] }
end

describe security_policy do
      its('SeInteractiveLogonRight') { should eq ['S-1-5-32-544', 'S-1-5-32-545', 'S-1-5-32-551'] }
end

describe registry_key('Interactive Logon CTRL+ALT+DEL','HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System') do
    its('DisableCAD') { should eq 0 }
end

describe registry_key('NTP Client','HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\W32time\\TimeProviders\\NtpClient') do
    its('Enabled') { should eq 1 }
end

describe registry_key('NTP Server','HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\W32time\\TimeProviders\\NtpServer') do
    its('Enabled') { should eq 0 }
end
