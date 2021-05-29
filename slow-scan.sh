#!/bin/bash
for port in {}
do
	/root/masscan -p $ip 192.168.1.1/16 --open --banner --rate 5000 
	sleep 5
done
