#!/bin/sh
#
# set system time from/to hardware clock		-- zxh(imzxh@yahoo.com)

guess_tz()	# guess tz from $LANG. just a wild guess, better than none :P
{
  ZONE_TABLE=$ZONE_DIR/zone.tab
  [ -f "$ZONE_TABLE" ] || {
    echo "$ZONE_TABLE not exists. Fallback to Asia/Jakarta."
    TIME_ZONE=Asia/Jakarta
    return 1
  }

  # this script should also run in distros other than cdlinux
  [ -f /etc/cdlinux/.conf ] && . /etc/cdlinux/.conf
  [ -n "$VAR_FILE" ] && [ -f "$VAR_FILE" ] && . "$VAR_FILE"
  _LANG_=${LANG:-$CDL_LANG}
  _LANG_=${_LANG_:-en_US.UTF-8}

  ZCODE=`echo $_LANG_ | cut -d'.' -f1 | cut -d'_' -f2 | cut -d'@' -f1`
  [ -z "$ZCODE" ] && {
    echo "Failed to guess country/zone code for $_LANG_. Fallback to Asia/Jakarta."
    TIME_ZONE=Asia/Jakarta
    return 2
  }

  TIME_ZONE=`awk -v zc="$ZCODE" '{if ($1 == zc) print $3}' "$ZONE_TABLE" | head -n 1`
  [ -f "$ZONE_DIR/$TIME_ZONE" ] || {
    echo "Failed to guess time zone. Fallback to Asia/Jakarta."
    TIME_ZONE=Asia/Jakarta
    return 3
  }
}

set_tz()
{
  [ -z "$TIME_ZONE" ] && {
    echo "Time zone not set. Fallback to Asia/Jakarta."
    TIME_ZONE=Asia/Jakarta
  }

  ZONE_FILE=$ZONE_DIR/$TIME_ZONE
  [ -f "$ZONE_FILE" ] || { echo "$ZONE_FILE not exists."; return 1; }
  diff -q "$ZONE_FILE" /etc/localtime &>/dev/null ||
    cp -f "$ZONE_FILE" /etc/localtime || {
      echo "Can't copy $ZONE_FILE to /etc/localtime."
      return 2
    }

  [ -f /etc/default/hwclock ] &&
    [ "$TIME_ZONE" = "`sed -n 's/^[[:blank:]]*TIME_ZONE[[:blank:]]*=[[:blank:]]*\([^ ]\+\)/\1/p' /etc/default/hwclock | tail -n 1`" ] &&
      return 0 ||
        sed -i "/^[[:blank:]]*TIME_ZONE[[:blank:]]*=/d" /etc/default/hwclock
  echo "TIME_ZONE=$TIME_ZONE" >>/etc/default/hwclock
}

start()
{
  hwclock -$HC_OPT -s
  # setup log daemons
  killall -9 syslogd >/dev/null 2>/dev/null
  killall -9 klogd >/dev/null 2>/dev/null
  syslogd -l 7 -s 1024 -b 10
  klogd
}

stop()
{
  hwclock -$HC_OPT -w
}


ZONE_DIR=/usr/share/zoneinfo

[ -f /etc/default/hwclock ] && . /etc/default/hwclock

HWCLOCK_Asia/Jakarta=${HWCLOCK_Asia/Jakarta:-yes}
case "$HWCLOCK_Asia/Jakarta" in
  [yY]|[yY][eE][sS]|[tT][rR][uU][eE]|1) HC_OPT=u;;
  *) HC_OPT=l ;;
esac

[ -z "$TIME_ZONE" ] && guess_tz
set_tz || exit 1

case "$1" in
  start)   start ;;
  stop)	   stop ;;
  restart) start ;;
  *)	   echo "Usage:  `basename $0` start|stop|restart" ;;
esac
