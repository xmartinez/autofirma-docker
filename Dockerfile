FROM ubuntu:20.04 as base
COPY scripts/apt-install.sh /usr/local/bin

######################################################################
# AutoFirma Debian package.

FROM base as autofirma-deb

RUN apt-install.sh ca-certificates wget unzip
RUN wget -q -O /tmp/autofirma.zip \
    https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma_Linux.zip
RUN unzip /tmp/autofirma.zip AutoFirma_1_6_5.deb -d /tmp

######################################################################
# Firefox

FROM base as firefox

RUN apt-install.sh ca-certificates wget
RUN wget -q -O /tmp/firefox.tar.bz2 \
    https://download-installer.cdn.mozilla.net/pub/firefox/releases/78.6.1esr/linux-x86_64/en-US/firefox-78.6.1esr.tar.bz2
RUN tar -C /opt -xjf /tmp/firefox.tar.bz2

######################################################################
# Install Firefox and AutoFirma.

FROM base

# Install Firefox.
RUN apt-install.sh libgtk-3-0 libdbus-glib-1-2 libxt6 p11-kit
COPY --from=firefox /opt/firefox /opt/firefox

# Install AutoFirma.
RUN apt-install.sh libnss3-tools openjdk-13-jre
COPY --from=autofirma-deb /tmp/AutoFirma_1_6_5.deb /tmp/
RUN apt-install.sh /tmp/AutoFirma_1_6_5.deb
COPY scripts/setup-autofirma.sh /usr/local/bin
RUN /usr/local/bin/setup-autofirma.sh

# Firefox wrapper.
COPY scripts/firefox /usr/local/bin

# Set up extrausers.
RUN apt-install.sh libnss-extrausers
COPY config/nsswitch.conf /etc/nsswitch.conf

WORKDIR "/home"
ENTRYPOINT ["/usr/local/bin/firefox"]
CMD ["https://sede.carm.es/cryptoApplet/ayuda/probarautofirma.html"]
