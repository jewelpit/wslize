FROM fedora:latest

# Add man pages first so we have to reinstall the fewest packages.
RUN dnf install -y man man-pages
RUN dnf reinstall -qy $(dnf repoquery --installed --qf "%{name}")

RUN dnf upgrade -y && dnf install -y \
    cracklib-dicts \
    findutils \
    iproute \
    iputils \
    man \
    man-pages \
    ncurses \
    passwd \
    procps-ng \
    rsync \
    util-linux \
    vim
RUN dnf clean all

RUN useradd -G wheel julia
RUN printf "\n[user]\ndefault = julia\n" | sudo tee -a /etc/wsl.conf

ENTRYPOINT passwd julia