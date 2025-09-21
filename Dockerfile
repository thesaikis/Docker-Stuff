FROM archlinux:latest

RUN pacman -Syu --noconfirm openssh sudo vim wget which

RUN sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && ssh-keygen -A

ARG LANG_PACKAGES=""
RUN if [ -n "$LANG_PACKAGES" ]; then \
        pacman -Sy --noconfirm $LANG_PACKAGES && \
        pacman -Scc --noconfirm; \
    fi

RUN passwd -d root

WORKDIR /root

# Install Exercism CLI
RUN mkdir -p /root/bin \
    && wget -q https://github.com/exercism/cli/releases/download/v3.5.7/exercism-3.5.7-linux-x86_64.tar.gz -O /tmp/exercism.tar.gz \
    && tar -xf /tmp/exercism.tar.gz -C /root/bin \
    && rm /tmp/exercism.tar.gz \
    && echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
