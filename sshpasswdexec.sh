#!/bin/bash
ip=$3
user=$1
pass=$2
cmd=$4
date "+[%Y-%m-%d %H:%M:%S] $cmd" | tee -a $ip.txt
sshpasswd -ip $ip -u $user -k $pass -c "$cmd" | tee -a $ip.txt
