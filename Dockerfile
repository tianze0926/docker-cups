FROM archlinux AS layers
RUN pacman -Syu --noconfirm &&\
    pacman -S --noconfirm cups hplip

FROM scratch
COPY --from=layers / /

CMD ["/usr/bin/cupsd", "-f"]