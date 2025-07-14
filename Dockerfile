FROM alpine
RUN apk add -U \
  bash \
  bind-tools 	\
  busybox-extras 	\
  curl \
  fd \
  fish \
  fish \
  fzf \
  git \
  hey \
  htop \
  mtr \
  postgresql-client \
  redis \
  ripgrep \
  ripgrep \
  scc \
  sqlite \
  sudo \
  tcpdump \
  util-linux \
  wget \
  zoxide

RUN /bin/sh -c echo "Set disable_coredump false" | tee -a /etc/sudo.conf
RUN sed 's;/bin/ash;/usr/bin/fish;g' /etc/passwd
WORKDIR /dotfiles
COPY . .
RUN /bin/sh -c 'touch /bin/chsh && chmod +x /bin/chsh && ./setup'

WORKDIR /root
SHELL [ "fish", "--command" ]
ENTRYPOINT ["fish"]
