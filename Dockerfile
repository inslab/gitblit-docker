# Basics
#
from ubuntu:14.04
maintainer Sunchan Lee <sunchanlee@inslab.co.kr>
run apt-get update
run apt-get install -q -y git-core redis-server

# Install Java 7

run DEBIAN_FRONTEND=noninteractive apt-get install -q -y software-properties-common
run DEBIAN_FRONTEND=noninteractive apt-get install -q -y python-software-properties
run DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:webupd8team/java -y
run apt-get update
run echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
run DEBIAN_FRONTEND=noninteractive apt-get install oracle-java7-installer -y

# Install Gitblit
run apt-get install -q -y curl
run curl -Lks http://dl.bintray.com/gitblit/releases/gitblit-1.6.2.tar.gz -o /root/gitblit.tar.gz
run mkdir -p /opt/gitblit
run tar zxf /root/gitblit.tar.gz -C /opt/gitblit
run rm -f /root/gitblit.tar.gz

# Move the data files to a separate directory
run mkdir -p /opt/gitblit-data
run mkdir -p /tmp/gitblit-data
add start.sh /opt/gitblit/start.sh
run chmod 777 /opt/gitblit/start.sh
run mv /opt/gitblit/data/* /tmp/gitblit-data
run mv /tmp/gitblit-data/gitblit.properties /tmp/gitblit-data/default.properties

# Adjust the default Gitblit settings to bind to 80, 443, 9418, 29418, and allow RPC administration.
#
# Note: we are writing to a different file here because sed doesn't like to the same file it
# is streaming.  This is why the original properties file was renamed earlier.
run sed -e "s/server\.httpsPort = 8443/server\.httpsPort=443/" \
        -e "s/server\.httpPort = 0/server\.httpPort=80/" \
        -e "s/server\.contextPath = \//server\.contextPath=\/gitblit/" \
        -e "s/web\.enableRpcManagement = false/web\.enableRpcManagement=true/" \
        -e "s/web\.enableRpcAdministration = false/web.enableRpcAdministration=true/" \
        -e "s/web\.mountParameters = true/web\.mountParameters = false/" \
        /tmp/gitblit-data/default.properties > /tmp/gitblit-data/gitblit.properties

#ENV LDAP_URI
#ENV LDAP_BASE_DN

# Setup the Docker container environment and run Gitblit
workdir /opt/gitblit
expose 80
expose 443
expose 9418
expose 29418
cmd ["/opt/gitblit/start.sh"]
