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



