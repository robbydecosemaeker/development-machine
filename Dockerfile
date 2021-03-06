FROM ubuntu

ENV INTELLIJ_URL=https://download.jetbrains.com/idea/ideaIU-2016.3.tar.gz
ENV VS_CODE_URL=https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable
ENV DISPLAY=192.168.1.1:0.0
ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -m -p dev dev
VOLUME ["/home/dev"]

RUN apt-get update

# making sure a display manager and X11 client are installed: https://help.ubuntu.com/community/ServerGUI
RUN apt-get install -yqq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
 libgtk2.0-bin \
 #special for vs code
 libnotify4 \
 libnss3 \
 libasound2 \
 gconf-service \
 libxss1
 
 

# Oracle Java 8
RUN  apt-get install -yqq software-properties-common \
 && apt-add-repository -y ppa:webupd8team/java \
 && apt-get -qq update \
 && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
 && apt-get install -yqq oracle-java8-set-default \
 && apt-get --purge autoremove -y software-properties-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Intellij
RUN wget --progress=bar:force $INTELLIJ_URL -O /tmp/intellij.tar.gz \
	&& mkdir /opt/intellij \
	&& tar -xzf /tmp/intellij.tar.gz -C /opt/intellij --strip-components=1 \
	&& rm -rf /tmp/*

# Visual Studio Code
RUN wget --progress=bar:force $VS_CODE_URL -O /tmp/vscode.deb \
 && dpkg -i /tmp/vscode.deb \
 && rm -rf /tmp/*


USER dev

SHELL ["bash"]
