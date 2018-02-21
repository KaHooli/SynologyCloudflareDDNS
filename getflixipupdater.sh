#!/bin/sh

# DSM Config
__USERNAME__="$(echo ${@} | cut -d' ' -f1)"
__PASSWORD__="$(echo ${@} | cut -d' ' -f2)"
__HOSTNAME__="$(echo ${@} | cut -d' ' -f3)"
__MYIP__="$(echo ${@}  | cut -d' ' -f4)"

# log location
__LOGFILE__="/var/log/cloudflareddns.log"

# CloudFlare Config
__RECTYPE__="A"
__RECID__=""
__ZONE_ID__=""
__TTL__="1"
__PROXY__="true"

log() {
    __LOGTIME__=$(date +"%b %e %T")
    if [ "${#}" -lt 1 ]; then
        false
    else
        __LOGMSG__="${1}"
    fi
    if [ "${#}" -lt 2 ]; then
        __LOGPRIO__=7
    else
        __LOGPRIO__=${2}
    fi

    logger -p ${__LOGPRIO__} -t "$(basename ${0})" "${__LOGMSG__}"
    echo "${__LOGTIME__} $(basename ${0}) (${__LOGPRIO__}): ${__LOGMSG__}" >> ${__LOGFILE__}
}

__URL__="https://www.getflix.com.au/api/v1/addresses.json"

# Update DNS record:
log "Updating with ${__MYIP__}..."
__RESPONSE__=$(curl -u ${__USERNAME__}:x -X GET \
     "${__URL__}" \
     -H "Content-Type: application/json"

# Strip the result element from response json
__RESULT__=$(echo ${__RESPONSE__} | grep -Po '"success":\K.*?[^\\],')
echo ${__RESPONSE__}
case ${__RESULT__} in
    'true,')
        __STATUS__='good'
        true
        ;;
    *)
        __STATUS__="${__RESULT__}"
        log "__RESPONSE__=${__RESPONSE__}"
        false
        ;;
esac
log "Status: ${__STATUS__}"

printf "%s" "${__STATUS__}"
