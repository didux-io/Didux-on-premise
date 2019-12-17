FROM debian:10.2
MAINTAINER elkan@didux.io

# Make directories
RUN mkdir -p /opt/didux/bin
RUN mkdir -p /opt/didux/data
RUN mkdir -p /opt/didux/keys
RUN mkdir -p /opt/didux/nodekeys

# Install binaries
ADD https://github.com/didux-io/Didux-blackbox/releases/download/first/blackbox-linux-amd64 /opt/didux/bin/blackbox
COPY onpremise/bin/ /opt/didux/bin/
RUN chmod +x /opt/didux/bin/*

# Add config files
COPY onpremise/genesis.json /opt/didux/data/
COPY onpremise/passwords.txt /opt/didux/data/
COPY onpremise/keys/ /opt/didux/keys/
COPY onpremise/nodekeys/ /opt/didux/nodekeys/
COPY onpremise/blackbox-config.json /opt/didux/data/blackbox-config.json



# Start
#CMD ["VAULT_IPC=/opt/didux/data/blackbox.ipc", "/opt/didux/bin/go-didux", $ARGS]
CMD ["/opt/didux/bin/wrapper.sh"]