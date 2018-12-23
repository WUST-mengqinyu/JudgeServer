FROM registry.cn-hangzhou.aliyuncs.com/badcw-oj/oj-server-init

COPY build/java_policy /etc

RUN cd /tmp && git clone -b master  --depth 1 https://github.com/badcw-OnlineJudge/Judger && cd Judger && \ 
    mkdir build && cd build && cmake .. && make && make install && cd ../bindings/Python && python3 setup.py install && \
    apt-get purge -y --auto-remove $buildDeps && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /code && \
    useradd -u 12001 compiler && useradd -u 12002 code && useradd -u 12003 spj && usermod -a -G code spj

HEALTHCHECK --interval=5s --retries=3 CMD python3 /code/service.py
ADD server /code
WORKDIR /code
EXPOSE 8080
ENTRYPOINT /code/entrypoint.sh
