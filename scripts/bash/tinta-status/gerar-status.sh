#!/bin/bash

OUTPUT="$HOME/tinta-status/tinta-status-gerado.html"
LOG="$HOME/tinta-status/tinta-status.log"
PUBLICADO="/var/www/html/tinta-status/index.html"
TEMP_PUBLICADO="/var/www/html/tinta-status/index.html.tmp"


HOST=$(hostname)
DATA=$(date)
UPTIME=$(uptime -p)
NGINX=$(systemctl is-active nginx)
BUILD_ID=$(date -u '+%Y%m%dT%H%M%SZ')


RAM_TOTAL=$(free -h | grep '^Mem:' | awk '{print $2}')
RAM_USADA=$(free -h | grep '^Mem:' | awk '{print $3}')
RAM_DISPONIVEL=$(free -h | grep '^Mem:' | awk '{print $7}')

DISCO_TOTAL=$(df -h / | tail -n 1 | awk '{print $2}')
DISCO_USADO=$(df -h / | tail -n 1 | awk '{print $3}')
DISCO_LIVRE=$(df -h / | tail -n 1 | awk '{print $4}')
DISCO_PERCENTUAL=$(df -h / | tail -n 1 | awk '{print $5}')
DISCO_NUM="${DISCO_PERCENTUAL%\%}"

if [ "$DISCO_NUM" -ge 90 ]; then
    DISCO_STATUS="CRITICAL"
elif [ "$DISCO_NUM" -ge 80 ]; then
    DISCO_STATUS="WARNING"
else
    DISCO_STATUS="OK"
fi

cat > "$OUTPUT" <<EOF
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Tinta Lab Status</title>
</head>
<body>
    <h1>Tinta Lab Status v0.7</h1>

    <h2>Informações do servidor</h2>

    <p><strong>Hostname:</strong> $HOST</p>
    <p><strong>Atualizado em:</strong> $DATA</p>
    <p><strong>Uptime:</strong> $UPTIME</p>
    <p><strong>Nginx:</strong> $NGINX</p>
    <p><strong>Build ID:</strong> $BUILD_ID</p>

    <h2>Memória</h2>
        <p><strong>Total:</strong> $RAM_TOTAL</p>
        <p><strong>Utilizada:</strong> $RAM_USADA</p>
        <p><strong>Disponível:</strong> $RAM_DISPONIVEL</p>

    <h2>Filesystem raiz</h2>
        <p><strong>Total:</strong> $DISCO_TOTAL</p>
        <p><strong>Utilizado:</strong> $DISCO_USADO</p>
        <p><strong>Livre:</strong> $DISCO_LIVRE</p>
        <p><strong>Ocupação:</strong> $DISCO_PERCENTUAL</p>
        <p><strong>Status:</strong> $DISCO_STATUS</p>
</body>
</html>
EOF

AGORA=$(date '+%Y-%m-%d %H:%M:%S')

if cp "$OUTPUT" "$TEMP_PUBLICADO"; then

    if mv "$TEMP_PUBLICADO" "$PUBLICADO"; then
        echo "$AGORA - DEPLOY SUCCESS - build=$BUILD_ID - $PUBLICADO" >> "$LOG"
    else
        echo "$AGORA - DEPLOY ERROR - falha no rename para produção - build=$BUILD_ID" >> "$LOG"
        rm -f "$TEMP_PUBLICADO"
        exit 1
    fi

else
    echo "$AGORA - DEPLOY ERROR - falha ao criar arquivo temporário - build=$BUILD_ID" >> "$LOG"
    rm -f "$TEMP_PUBLICADO"
    exit 1
fi

HTTP_CODE=$(curl -sS -o /dev/null -w '%{http_code}' http://localhost/tinta-status/)
CURL_EXIT=$?

AGORA=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$CURL_EXIT" -eq 0 ] && [ "$HTTP_CODE" -eq 200 ]; then
    echo "$AGORA - HTTP SUCCESS - status=$HTTP_CODE" >> "$LOG"
else
    echo "$AGORA - HTTP ERROR - curl_exit=$CURL_EXIT status=$HTTP_CODE" >> "$LOG"
    exit 2
fi

if curl -sS http://localhost/tinta-status/ | grep -Fq "$BUILD_ID"; then
    echo "$AGORA - CONTENT SUCCESS - build=$BUILD_ID" >> "$LOG"
else
    echo "$AGORA - CONTENT ERROR - build esperado=$BUILD_ID não encontrado" >> "$LOG"
    exit 3
fi
