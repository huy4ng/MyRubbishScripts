#!/bin/bash
xray webscan --listen 0.0.0.0:40999 --plugins cmd_injection,phantasm,jsonp,ssrf,sqldet  --html-output `date +%Y%m%d`.html
