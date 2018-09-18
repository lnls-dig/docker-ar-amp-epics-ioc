FROM lnls/epics-dist:base-3.15-debian-9

ENV IOC_REPO ar-amp-epics-ioc
ENV BOOT_DIR iocARAmp
ENV COMMIT v0.1.0

RUN git clone https://github.com/lnls-dig/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${COMMIT} && \
    echo 'EPICS_BASE=/opt/epics/base' > configure/RELEASE.local && \
    echo 'SUPPORT=/opt/epics/synApps-lnls-R0-0-2/support' >> configure/RELEASE.local && \
    echo 'AUTOSAVE=$(SUPPORT)/autosave-R5-9' >> configure/RELEASE.local && \
    echo 'CALC=$(SUPPORT)/calc-R3-7' >> configure/RELEASE.local && \
    echo 'STREAM=$(SUPPORT)/stream-R2-7-7' >> configure/RELEASE.local && \
    echo 'ASYN=$(SUPPORT)/asyn-R4-33' >> configure/RELEASE.local && \
    make && \
    make install

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]