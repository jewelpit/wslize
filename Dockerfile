FROM registry.fedoraproject.org/fedora-toolbox:testing

RUN dnf upgrade -y && dnf install -y neofetch
RUN dnf clean all

# Save this so we can use it in CMD below.
ARG USERNAME
ENV USERNAME="${USERNAME}"
RUN test -n "${USERNAME}"

RUN useradd -G wheel ${USERNAME}
RUN printf "\n[user]\ndefault = ${USERNAME}\n" | sudo tee -a /etc/wsl.conf

CMD neofetch && passwd ${USERNAME}