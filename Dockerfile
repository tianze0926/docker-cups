FROM archlinux AS layers
RUN pacman -Syu --noconfirm &&\
    pacman -S --noconfirm cups hplip

COPY --chown=root:cups cupsd.conf /etc/cups/cupsd.conf

RUN pacman -Scc

FROM scratch
COPY --from=layers / /

CMD ["/usr/bin/cupsd", "-f"]