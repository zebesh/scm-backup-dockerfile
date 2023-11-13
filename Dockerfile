FROM alpine:3.18

ARG SCM_FILE=scm-backup-1.7.1.09b3532.zip
ARG DOTNET_FILE=dotnet-sdk-3.1.426-linux-musl-x64.tar.gz
ARG DOTNET_FILE_SHA512=2854eaeb79b29fce1ae31f2253adb2d8f199b7d5a988fc8c90130afe3df6668893d87c14a86932254bdbaec64a553d7b996bbd6868ba7858e3a2cb28c5e9576d

ENV SCM_ROOT=/opt/scm-backup
ENV DOTNET_ROOT=/opt/dotnet
ENV PATH=${PATH}:${DOTNET_ROOT}

WORKDIR ${SCM_ROOT}

RUN apk add --no-cache \
    bash icu-libs krb5-libs \
    libgcc libintl libssl1.1 \
    libstdc++ zlib curl git yq

    # Install dotnet runtime
RUN curl -fsL -o ${DOTNET_FILE} https://download.visualstudio.microsoft.com/download/pr/f8834fef-d2ab-4cf6-abc3-d8d79cfcde11/0ee05ef4af5fe324ce2977021bf9f340/${DOTNET_FILE} \
    && echo "${DOTNET_FILE_SHA512}  ${DOTNET_FILE}" > ${DOTNET_FILE}.sha512 \
    && sha512sum -c ${DOTNET_FILE}.sha512 \
    && mkdir -p ${DOTNET_ROOT} \
    && tar zxf ${DOTNET_FILE} -C ${DOTNET_ROOT} \
    && rm -f ${DOTNET_FILE} ${DOTNET_FILE}.sha512
    # Install scm-backup
RUN curl -fsL -o ${SCM_FILE} https://github.com/christianspecht/scm-backup/releases/download/1.7.1/${SCM_FILE} \
    && unzip ${SCM_FILE} \
    && rm -f ${SCM_FILE}

COPY entrypoint.sh /usr/local/bin
COPY settings.yml .
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]