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

case "$DISCO_STATUS" in
    OK)
        DISCO_CLASS="ok"
        ;;
    WARNING)
        DISCO_CLASS="warning"
        ;;
    CRITICAL)
        DISCO_CLASS="critical"
        ;;
    *)
        DISCO_CLASS="unknown"
        ;;
esac

case "$NGINX" in
    active)
        NGINX_STATUS="OK"
        NGINX_CLASS="ok"
        ;;
    inactive|failed)
        NGINX_STATUS="CRITICAL"
        NGINX_CLASS="critical"
        ;;
    *)
        NGINX_STATUS="UNKNOWN"
        NGINX_CLASS="unknown"
        ;;
esac

if [ "$NGINX_STATUS" = "CRITICAL" ] || [ "$DISCO_STATUS" = "CRITICAL" ]; then
    GERAL_STATUS="CRITICAL"
    GERAL_CLASS="critical"
elif [ "$DISCO_STATUS" = "WARNING" ]; then
    GERAL_STATUS="WARNING"
    GERAL_CLASS="warning"
else
    GERAL_STATUS="OK"
    GERAL_CLASS="ok"
fi

cat > "$OUTPUT" <<EOF
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Tinta Lab Status</title>
    <style>
    body {
        font-family: Arial, sans-serif;
        background: #111827;
        color: #e5e7eb;
        margin: 0;
        padding: 30px;
    }

    .container {
        max-width: 900px;
        margin: auto;
    }

    .card {
        background: #1f2937;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
    }

    .status {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 6px;
        font-weight: bold;
    }

    .ok {
        background: #14532d;
        color: #bbf7d0;
    }

    .warning {
        background: #713f12;
        color: #fde68a;
    }

    .critical {
        background: #7f1d1d;
        color: #fecaca;
    }

    .unknown {
        background: #374151;
        color: #d1d5db;
    }

    .metric {
        margin: 8px 0;
    }

    .build {
        color: #9ca3af;
        font-size: 0.85rem;
    }
    </style>
</head>
<body>
<div class="container">

    <h1>Tinta Lab Status v0.8</h1>

    <div class="card">
        <h2>Overall Status</h2>
        <span class="status $GERAL_CLASS">$GERAL_STATUS</span>

        <p class="metric"><strong>Hostname:</strong> $HOST</p>
        <p class="metric"><strong>Uptime:</strong> $UPTIME</p>
        <p class="metric"><strong>Updated:</strong> $DATA</p>
        <p class="build"><strong>Build ID:</strong> $BUILD_ID</p>
    </div>

    <div class="card">
        <h2>Nginx</h2>
        <span class="status $NGINX_CLASS">$NGINX_STATUS</span>
        <p class="metric"><strong>systemd state:</strong> $NGINX</p>
    </div>

    <div class="card">
        <h2>Memory</h2>
        <p class="metric"><strong>Total:</strong> $RAM_TOTAL</p>
        <p class="metric"><strong>Used:</strong> $RAM_USADA</p>
        <p class="metric"><strong>Available:</strong> $RAM_DISPONIVEL</p>
    </div>

    <div class="card">
        <h2>Root Filesystem</h2>
        <span class="status $DISCO_CLASS">$DISCO_STATUS</span>

        <p class="metric"><strong>Total:</strong> $DISCO_TOTAL</p>
        <p class="metric"><strong>Used:</strong> $DISCO_USADO</p>
        <p class="metric"><strong>Available:</strong> $DISCO_LIVRE</p>
        <p class="metric"><strong>Usage:</strong> $DISCO_PERCENTUAL</p>
    </div>

</div>
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
