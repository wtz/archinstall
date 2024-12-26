#!/bin/bash
# log_dbus_address.sh

# 获取当前的 DBUS_SESSION_BUS_ADDRESS 并将其写入到 log 文件中
echo $DBUS_SESSION_BUS_ADDRESS > $HOME/.dbus_address_log

