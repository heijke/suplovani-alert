#!/bin/bash

suplovani=$(curl -s "https://www.ssps.cz/" | sed -n -e '/supplementation-report/,/<\/div>/p' | grep " $1?*" | sed -E 's/(<li>|<\/li>)//g' | tr -d '\r' | tr '\n' ';'| xargs | sed 's/\xc2\xa0//g')
if [[ "${suplovani}" != "" && "$(tail -n2 /var/log/suplovani.log | grep "$1" | cut -d ' ' -f3-)" != "${suplovani}" ]]; then
  printf "[$(date '+%d/%m/%Y:%H:%M:%S')] [$1] ${suplovani}\n" >> /var/log/suplovani.log
  echo "${suplovani}" | tr ";" "\n" | sed 's/^ //g' | mail -s "Suplovani alert" -aFrom:suplovani@labutejsounej.eu $2
elif [[ "${suplovani}" == "" ]]; then
  printf "[$(date '+%d/%m/%Y:%H:%M:%S')] [$1] String je null, žádná suplování\n" >> /var/log/suplovani.log
fi

