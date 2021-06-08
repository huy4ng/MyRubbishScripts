#!/bin/bash
curl -s "https://urlscan.io/api/v1/search/?q=domain:$1" | grep -E '"url"' | cut -d '"' -f4 | grep -F $1 | sort -u
