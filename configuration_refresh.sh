#!/bin/bash

interval_in_seconds=10

rinetd_conf_refresh() {
	rinetd_file_path="/etc"
	rinetd_file=$rinetd_file_path"/rinetd.conf"
	rinetd_file_git="rinetd.conf"

	diff -q $rinetd_file_git $rinetd_file &>/dev/null
	if [[ $? == "0" ]]; then
	  echo "rinetd.conf degismemis."
	else
	  echo "rinetd.conf degismis.."
	  cp $rinetd_file_git $rinetd_file_path
	  sudo systemctl reload rinetd && echo "degisiklik uygulandi!"
	fi
}

stream_conf_refresh() {
	stream_file_path="/etc/nginx/modules-available"
	stream_file=$stream_file_path"/stream.conf"
	stream_file_git="stream.conf"

	diff -q $stream_file_git $stream_file &>/dev/null
	if [[ $? == "0" ]]; then
	  echo "stream.conf degismemis."
	else
	  echo "nginx stream.conf degismis.."
	  cp $stream_file_git $stream_file_path
	  sudo nginx -t && sudo systemctl reload nginx && echo "degisiklik uygulandi!"
	fi
}

while true; do

        git reset && git checkout . && git pull
	stream_conf_refresh
	rinetd_conf_refresh

	sleep $interval_in_seconds

done
