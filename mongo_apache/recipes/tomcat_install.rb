case node['platform']
    when 'rhel', 'amazon', 'fedora'
          puts '************RHEL'
    # Install Java
    package "Install Java" do
      package_name "java-1.7.0-openjdk-devel"
      action :install
    end

    # Create Tomcat Group
    group "tomcat" do
      action :create
    end

    # Create Tomcat user and add in the group
    user "tomcat" do
      gid "tomcat"
      home "/opt/tomcat"
      shell "/bin/nologin"
      action :create
    end

    # Download Tomcat Installer
    remote_file "/tmp/apache-tomcat-8.5.61.tar.gz" do
      source "https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.61/bin/apache-tomcat-8.5.61.tar.gz"
      owner "root"
      group "root"
      mode "0755"
      action :create
    end

    # Create Directory
    directory "/opt/tomcat" do
      owner "tomcat"
      group "tomcat"
      mode "0755"
      action :create
    end

    # Untar Tomcat Installer
    execute "Untar Tomcat Installer" do
      command 'sudo tar xvf /tmp/apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
      action :run
      not_if { ::File.exist?('/etc/systemd/system/tomcat.service')}
    end

    # Set Permission
    execute "Set Permission for Tomcat" do
      command <<-EOF
        cd /opt/tomcat
        sudo chgrp -R tomcat /opt/tomcat
        sudo chmod -R g+r conf
        sudo chmod g+x conf
        sudo chown -R tomcat webapps/ work/ temp/ logs/
      EOF
      action :run
      not_if { ::File.exist?('/etc/systemd/system/tomcat.service')}
    end

    # Reload systemctl daemon
    execute "Reload systemctl" do
      command "sudo systemctl daemon-reload"
      action :nothing
    end

    # Load the service file
    template "/etc/systemd/system/tomcat.service" do
      source "tomcat.service.erb"
      owner "root"
      group "root"
      mode "0755"
      action :create
    #  notifies :run, 'execute[systemctl Reload]', :immediately
    end

    # Reload systemctl daemon
    execute "Reload systemctl" do
      command "sudo systemctl daemon-reload"
      action :nothing
    end

    # Start and Enable service
    service "tomcat.service" do
      action [ :enable, :start ]
    end
    when 'ubuntu'
      puts '********************---------------ubuntu'
      # Update apt
      apt_update "Update the apt" do
        frequency 86400
        action :periodic
      end

      # Install Java
      apt_package "default-jdk" do
        action :install
      end

      # Create Tomcat Group
      group "tomcat" do
        action :create
      end

      # Create Tomcat user and add in the group
      user "tomcat" do
        gid "tomcat"
        home "/opt/tomcat"
        shell "/bin/false"
        action :create
      end

      # Download Tomcat Installer
      remote_file "/tmp/apache-tomcat-8.5.61.tar.gz" do
        source "https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.61/bin/apache-tomcat-8.5.61.tar.gz"
        owner "root"
        group "root"
        mode "0755"
        action :create
      end
  
      # Create Directory
      directory "/opt/tomcat" do
        owner "tomcat"
        group "tomcat"
        mode "0755"
        action :create
      end

      # Untar Tomcat Installer
      execute "Untar Tomcat Installer" do
        command 'sudo tar xvf /tmp/apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
        action :run
        not_if { ::File.exist?('/etc/systemd/system/tomcat.service')}
      end

      # Set Permission
       execute "Set Permission for Tomcat" do
       command <<-EOF
          cd /opt/tomcat
          sudo chgrp -R tomcat /opt/tomcat
          sudo chmod -R g+r conf
          sudo chmod g+x conf
          sudo chown -R tomcat webapps/ work/ temp/ logs/
        EOF
        action :run
        not_if { ::File.exist?('/etc/systemd/system/tomcat.service')}
      end

      # Reload systemctl daemon
      execute "Reload systemctl" do
        command "sudo systemctl daemon-reload"
        action :nothing
      end

      # Load the service file
      template "/etc/systemd/system/tomcat.service" do
        source "tomcat_u.service.erb"
        owner "root"
        group "root"
        mode "0755"
        action :create
      end

      # Reload systemctl daemon
      execute "Reload systemctl" do
        command "sudo systemctl daemon-reload"
        action :nothing
      end

      # Start and Enable service
      service "tomcat.service" do
        supports :status => true, :restart => true, :reload => true
        action [ :enable, :start ]
      end
end
