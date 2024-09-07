#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091,SC2154,SC1003,SC2005

current_dir="$(pwd)"
unypkg_script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
unypkg_root_dir="$(cd -- "$unypkg_script_dir"/.. &>/dev/null && pwd)"

cd "$unypkg_root_dir" || exit

#############################################################################################
### Start of script

mkdir -pv /etc/uny/redis
cp -a etc/redis.conf /etc/uny/redis/

mkdir -pv /var/lib/redis

cp -a utils/systemd-redis_server.service /etc/systemd/system/uny-redis-server.service
sed "s|--supervised systemd --daemonize no|/etc/uny/redis/redis.conf|" -i /etc/systemd/system/uny-redis-server.service
sed -e '/\[Install\]/a\' -e 'Alias=redis-server.service redis.service' -i /etc/systemd/system/uny-redis-server.service
systemctl daemon-reload

#############################################################################################
### End of script

cd "$current_dir" || exit
