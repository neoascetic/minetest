FROM debian:stable-slim
ADD https://github.com/minetest/minetest/archive/backport-0.4.tar.gz /build/
RUN cd /build && tar xf backport-0.4.tar.gz --strip-component=1 && rm -rf backport-0.4.tar.gz
ADD https://github.com/minetest/minetest_game/archive/backport-0.4.tar.gz /build/games/minetest_game/
RUN cd /build/games/minetest_game && tar xf backport-0.4.tar.gz --strip-component=1 && rm backport-0.4.tar.gz
RUN apt-get update\
    && apt-get install -y --no-install-recommends g++ make cmake libirrlicht-dev libhiredis-dev libleveldb-dev libsqlite3-dev libcurl4-gnutls-dev libluajit-5.1-dev libgmp-dev zlib1g-dev libspatialindex-dev libpq-dev postgresql-server-dev-all\
    && cd /build\
    && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_CLIENT=0 -DBUILD_SERVER=1 -DRUN_IN_PLACE=0 -DENABLE_LEVELDB=1 -DENABLE_REDIS=1 -DENABLE_SPATIAL=1 -DENABLE_POSTGRESQL=1 . && make -j4 install\
    && apt-get remove --auto-remove --purge -y g++ make cmake\
    && apt-get clean && rm -rf /var/lib/apt/lists/*\
    && rm -rf /build

EXPOSE 30000/udp
WORKDIR /root/.minetest
VOLUME /root/.minetest
ENTRYPOINT ["minetestserver", "--logfile", "/dev/null"]
