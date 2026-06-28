#!/bin/bash

CPU=$(top -bn2 -d 0.1 | grep "Cpu(s)" | tail -n 1 | awk '{print int($2 + $4)}')
MEM=$(free | grep Mem | awk '{print int($3/$2 * 100)}')

if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
    TEMP=$(awk '{print int($1/1000)}' /sys/class/thermal/thermal_zone0/temp)
else
    TEMP="N/A"
fi

# --- DYNAMIC COLOR LOGIC ---

LOW="#70bf56"  # Clean Green
MID="#fdb04c"  # Warn Orange
HIGH="#f06b73" # Crit Red

# 1. Temperature & Class Logic
TEMP_COLOR=$LOW
TEMP_CLASS="normal" # Default state for style.css

if [ "$TEMP" != "N/A" ]; then
    if [ "$TEMP" -ge 75 ]; then
        TEMP_COLOR=$HIGH
        TEMP_CLASS="critical"
    elif [ "$TEMP" -ge 60 ]; then
        TEMP_COLOR=$MID
        TEMP_CLASS="warning"
    fi
fi

# 2. CPU Color Logic
CPU_COLOR=$LOW

if [ "$CPU" -ge 75 ]; then
    CPU_COLOR=$HIGH
elif [ "$CPU" -ge 60 ]; then
    CPU_COLOR=$MID
fi

# 3. RAM (Memory) Color Logic 
MEM_COLOR=$LOW

if [ "$MEM" -ge 75 ]; then
    MEM_COLOR=$HIGH
elif [ "$MEM" -ge 60 ]; then
    MEM_COLOR=$MID
fi

# --- CONSTRUCT TOOLTIP WITH MARKUP ---
TOOLTIP="<b><span color='#bfbdb6'>󰓅 SYSTEM PERFORMANCE</span></b>\\n"
TOOLTIP+="<span color='#f06b73'>-------------------------</span>\\n"
TOOLTIP+=" <b>CPU Load:</b> <span color='${CPU_COLOR}'>${CPU}%</span>\\n"
TOOLTIP+=" <b>RAM Used:</b> <span color='${MEM_COLOR}'>${MEM}%</span>\\n"
TOOLTIP+=" <b>SYS Temp:</b> <span color='${TEMP_COLOR}'>${TEMP}°C</span>"

# Now properly outputs your calculated ${TEMP_CLASS} to trigger CSS changes
echo "{\"text\": \"󰓅 \", \"tooltip\": \"<tt><small>${TOOLTIP}</small></tt>\", \"class\": \"${TEMP_CLASS}\"}"
