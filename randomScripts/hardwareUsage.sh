#!/bin/bash
#
# Show system CPU, memory, disk, network usage + top memory-consuming processes
# Uses only built-in Linux commands (/proc and df)
#

echo "===== SYSTEM RESOURCE SUMMARY ====="

# --- MEMORY INFO ---
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')    # in KB
free_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}') # in KB
used_mem=$((total_mem - free_mem))

# convert to MB
total_mem_mb=$((total_mem / 1024))
used_mem_mb=$((used_mem / 1024))
free_mem_mb=$((free_mem / 1024))

echo "Memory (MB):  Total = ${total_mem_mb} MB,  Used = ${used_mem_mb} MB,  Free = ${free_mem_mb} MB"

# --- CPU INFO ---
cores=$(nproc)   # total number of logical CPU cores
cpu_line=$(grep "cpu " /proc/stat)
# user nice system idle iowait irq softirq steal guest guest_nice
cpu_values=($cpu_line)
idle=${cpu_values[4]}
total=0
for v in "${cpu_values[@]:1}"; do
    total=$((total + v))
done

sleep 1

cpu_line2=$(grep "cpu " /proc/stat)
cpu_values2=($cpu_line2)
idle2=${cpu_values2[4]}
total2=0
for v in "${cpu_values2[@]:1}"; do
    total2=$((total2 + v))
done

idle_diff=$((idle2 - idle))
total_diff=$((total2 - total))
cpu_used=$(echo "scale=2; (100 * ($total_diff - $idle_diff)) / $total_diff" | bc)

cores_used=$(echo "$cpu_used * $cores / 100" | bc)
cores_avail=$(echo "$cores - $cores_used" | bc)

echo "CPU Summary:"
echo "  Total Cores    : $cores"
echo "  CPU Used (%)   : $cpu_used%"
echo "  CPU Free (%)   : $(echo "100 - $cpu_used" | bc)%"
echo "  Cores in Use   : $cores_used"
echo "  Cores Free     : $cores_avail"

# --- DISK CAPACITY ---
echo ""
echo "Disk Capacity Usage:"
df -h --total | grep -E "Filesystem|total"

# --- DISK PERFORMANCE (/proc/diskstats) ---
echo ""
echo "Disk Performance (sectors read/write per sec):"

read rd1 wr1 <<< $(awk '{r+=$6; w+=$10} END {print r,w}' /proc/diskstats)
sleep 1
read rd2 wr2 <<< $(awk '{r+=$6; w+=$10} END {print r,w}' /proc/diskstats)

rd_s=$((rd2 - rd1))
wr_s=$((wr2 - wr1))

# sectors are typically 512 bytes
rd_kb=$((rd_s / 2))
wr_kb=$((wr_s / 2))

echo "  Read : $rd_kb KB/s"
echo "  Write: $wr_kb KB/s"

# --- NETWORK PERFORMANCE (/proc/net/dev) ---
echo ""
echo "Network Performance (Download / Upload):"

read rx1 tx1 <<< $(awk '/:/{print $2, $10}' /proc/net/dev | awk '{sum1+=$1; sum2+=$2} END {print sum1, sum2}')
sleep 1
read rx2 tx2 <<< $(awk '/:/{print $2, $10}' /proc/net/dev | awk '{sum1+=$1; sum2+=$2} END {print sum1, sum2}')

rx_rate=$(( (rx2 - rx1) / 1024 ))  # KB/s
tx_rate=$(( (tx2 - tx1) / 1024 ))  # KB/s

if [ $rx_rate -ge 1024 ]; then
    rx_display=$(echo "scale=2; $rx_rate/1024" | bc)" MB/s"
else
    rx_display="$rx_rate KB/s"
fi

if [ $tx_rate -ge 1024 ]; then
    tx_display=$(echo "scale=2; $tx_rate/1024" | bc)" MB/s"
else
    tx_display="$tx_rate KB/s"
fi

echo "  Download: $rx_display"
echo "  Upload  : $tx_display"

# --- TOP PROCESSES ---
echo ""
echo "===== TOP 10 MEMORY-CONSUMING PROCESSES ====="

ps aux --sort=-%mem | awk '
NR==1 {
    printf "%-10s %-10s %-8s %-8s %-12s %s\n","USER","PID","%CPU","%MEM","MEM_USAGE","COMMAND"; 
    next
} 
{
    mem=$6/1024; 
    if (mem > 1024) {
        printf "%-10s %-10s %-8s %-8s %-12s %s\n",$1,$2,$3,$4,mem/1024 " GB",$11
    } else {
        printf "%-10s %-10s %-8s %-8s %-12s %s\n",$1,$2,$3,$4,mem " MB",$11
    }
}' | head -n 11

