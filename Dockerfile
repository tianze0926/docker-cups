FROM archlinux AS layers

# prepare yay
RUN pacman -Syu --noconfirm &&\
    pacman -S --noconfirm git base-devel
RUN useradd --create-home --no-user-group -G 26 abc &&\
    echo 'abc ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers
USER abc
RUN cd &&\
    git clone https://aur.archlinux.org/yay-bin.git &&\
    cd yay-bin &&\
    makepkg --noconfirm -si &&\
    cd .. && rm -rf yay-bin

# install
RUN yay -S --noconfirm cups usbutils hplip hplip-plugin
COPY --chown=root:cups cupsd.conf /etc/cups/
COPY --chown=root:cups cups-files.conf /etc/cups/

# cleanup
RUN yes | yay -Scc &&\
    echo '' > /etc/sudoers
USER root
RUN pacman -Rs --noconfirm git base-devel yay &&\
    yes | pacman -Scc

# merge layers
FROM scratch
COPY --from=layers / /

CMD ["/usr/bin/cupsd", "-f"]