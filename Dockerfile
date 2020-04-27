FROM centos:6

ENV NAGIOSADMIN_USER       nagiosadmin
ENV NAGIOSADMIN_PASS       nagios
ENV NRDP_TOKEN             testtoken

# Install nagios and nagios plugins dependencies
RUN yum install -y gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix gettext make automake autoconf openssl-devel net-snmp net-snmp-utils epel-release
RUN yum install -y perl-Net-SNMP

WORKDIR /tmp

# Download nagios source
RUN wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.5.tar.gz && \
tar xzf nagioscore.tar.gz

WORKDIR /tmp/nagioscore-nagios-4.4.5/

# compile
RUN ./configure && \
make all

# Create user and group
RUN make install-groups-users && \
usermod -a -G nagios apache

# Install binaries
RUN make install

# Install service/daemon
RUN make install-daemoninit && \
chkconfig --level 2345 httpd on

# Install command mode
RUN make install-commandmode

# Install configuraion files
RUN make install-config
# Install apache config files
RUN make install-webconf

# Create nagiosadmin user account
RUN htpasswd -b -c /usr/local/nagios/etc/htpasswd.users ${NAGIOSADMIN_USER} ${NAGIOSADMIN_PASS}

WORKDIR /tmp

# Download nagios pluguin source
RUN wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz && \
tar zxf nagios-plugins.tar.gz

WORKDIR /tmp/nagios-plugins-release-2.2.1/

# Compile and install
RUN ./tools/setup && \
./configure && \
make && \
make install

# Install nrdp

WORKDIR /tmp
RUN wget -O nrdp.tar.gz https://github.com/NagiosEnterprises/nrdp/archive/1.5.1.tar.gz && \
tar xzf nrdp.tar.gz

WORKDIR /tmp/nrdp-1.5.1/
# Copy files
RUN mkdir -p /usr/local/nrdp && \
cp -r clients server LICENSE* CHANGES* /usr/local/nrdp && \
chown -R nagios:nagios /usr/local/nrdp

RUN cp nrdp.conf /etc/httpd/conf.d/
# Copy start services scripts
COPY start.sh /nagios/start.sh

CMD ["/bin/bash", "/nagios/start.sh"]
