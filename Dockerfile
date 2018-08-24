FROM centos:centos7

### Install System Base
RUN yum install -y epel-release yum wget \
&& yum update -y \
&& yum autoremove -y \
&& yum clean all -y \
&& rm -rf /var/cache/yum

### Install OpenVAS Requirements
ADD conf/texlive.repo /etc/yum.repos.d/texlive.repo
RUN export NON_INT=yes ; wget -q -O - http://www.atomicorp.com/installers/atomic | sh \
&& yum install -y \
wget \
bzip2 \
texlive \
texlive-changepage \
texlive-titlesec \
texlive-collection-latexextra \
net-tools \
useradd \
openssh \
alien \
gnutls-utils \
libselinux-utils \
openvas \
OSPd-nmap \
OSPd \
&& yum autoremove -y \
&& yum clean all -y \
&& rm -rf /var/cache/yum

# PDF fixes
RUN mkdir -p /usr/share/texlive/texmf-local/tex/latex/comment
ADD conf/comment.sty /usr/share/texlive/texmf-local/tex/latex/comment/comment.sty
RUN texhash

# Arachni
RUN wget https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
    tar xvf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
    mv arachni-1.5.1-0.5.12 /opt/arachni && \
    ln -s /opt/arachni/bin/* /usr/local/bin/ && \
    rm -rf arachni*

### OPENVAS - CONFIGURE
COPY conf/gsad /etc/sysconfig/gsad
COPY conf/openvasmd /etc/sysconfig/openvasmd
COPY bin/openvas-setup /usr/local/bin/openvas-setup
RUN chmod +x /usr/local/bin/openvas-setup
RUN sed -i -e "s/# \(unix.*\)/\1/" /etc/redis.conf

### Post-install
COPY bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# COPY bin/update-NVT /usr/local/bin/update-NVT
# RUN chmod +x /usr/local/bin/update-NVT
#COPY conf/auth.conf /var/lib/openvas/openvasmd/auth.conf

### Start
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 443 9390 9391 9292 

