#!/usr/bin/env bash
# Author: carana
# System Information Report Generator
# Compatible with RHEL 5.x, Ubuntu, and newer systems

#Checking paramerter
if [[ $1 != "before" && $1 != "after" ]]; then 
	echo "Usage: "
	echo "./$(basename $0)" "[before|after]"
	exit 1
fi

# Output file
OUTPUT_FILE="system_report_$1_$(hostname)_$(date +%Y%m%d_%H%M%S).txt"

# Function to create section separator
print_section() {
    echo "" >> "$OUTPUT_FILE"
    echo "================================================================================" >> "$OUTPUT_FILE"
    echo "  $1" >> "$OUTPUT_FILE"
    echo "================================================================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Header
cat > "$OUTPUT_FILE" << 'EOF'
================================================================================
                         SYSTEM INFORMATION REPORT                             
================================================================================

  ____  _   _ ____ _____ _____ __  __   ____  _____ ____   ___  ____ _____ 
 / ___|| | | / ___|_   _| ____|  \/  | |  _ \| ____||  _ \ / _ \|  _ |_   _|
 \___ \| | | \___ \ | | |  _| | |\/| | | |_) |  _|  | |_) | | | | |_) || |  
  ___) | |_| |___) || | | |___| |  | | |  _ <| |___ |  __/| |_| |  _ < | |  
 |____/ \___/|____/ |_| |_____|_|  |_| |_| \_|_____|_|    \___/|_| \_\|_|  
                                                                              
================================================================================
EOF

echo "Report Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "Hostname: $(hostname)" >> "$OUTPUT_FILE"

# OS Version and Details
print_section "1. OPERATING SYSTEM INFORMATION"

echo "Distribution Details:" >> "$OUTPUT_FILE"
echo "--------------------" >> "$OUTPUT_FILE"

# Try multiple methods to detect OS (compatible with old and new systems)
if [ -f /etc/os-release ]; then
    # Modern systems (RHEL 7+, Ubuntu 16.04+)
    grep -E "^(NAME|VERSION|ID|VERSION_ID|PRETTY_NAME)=" /etc/os-release | sed 's/^/  /' >> "$OUTPUT_FILE"
elif [ -f /etc/redhat-release ]; then
    # RHEL/CentOS 5.x, 6.x
    echo "  $(cat /etc/redhat-release)" >> "$OUTPUT_FILE"
elif [ -f /etc/lsb-release ]; then
    # Older Ubuntu
    cat /etc/lsb-release | sed 's/^/  /' >> "$OUTPUT_FILE"
elif [ -f /etc/debian_version ]; then
    # Debian-based
    echo "  Debian-based system" >> "$OUTPUT_FILE"
    echo "  Version: $(cat /etc/debian_version)" >> "$OUTPUT_FILE"
else
    echo "  Unable to determine distribution" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "Kernel Information:" >> "$OUTPUT_FILE"
echo "------------------" >> "$OUTPUT_FILE"
echo "  Kernel Version: $(uname -r)" >> "$OUTPUT_FILE"
echo "  Architecture: $(uname -m)" >> "$OUTPUT_FILE"
echo "  Hostname: $(uname -n)" >> "$OUTPUT_FILE"

# System Uptime
echo "" >> "$OUTPUT_FILE"
echo "System Uptime:" >> "$OUTPUT_FILE"
echo "-------------" >> "$OUTPUT_FILE"
# uptime -p doesn't exist in old versions
UPTIME_OUTPUT=$(uptime)
echo "  $UPTIME_OUTPUT" >> "$OUTPUT_FILE"

# Running Services Summary
print_section "2. RUNNING SERVICES SUMMARY"

if command -v systemctl >/dev/null 2>&1; then
    # systemd-based systems (RHEL 7+, Ubuntu 15.04+)
    echo "Service Status Overview (systemd):" >> "$OUTPUT_FILE"
    echo "----------------------------------" >> "$OUTPUT_FILE"
    systemctl list-units --type=service --state=running --no-pager --no-legend 2>/dev/null | \
        awk '{printf "  [+] %-50s %s\n", $1, $4}' >> "$OUTPUT_FILE"
    
    echo "" >> "$OUTPUT_FILE"
    echo "Service Count:" >> "$OUTPUT_FILE"
    echo "-------------" >> "$OUTPUT_FILE"
    RUNNING=$(systemctl list-units --type=service --state=running --no-pager --no-legend 2>/dev/null | wc -l)
    FAILED=$(systemctl list-units --type=service --state=failed --no-pager --no-legend 2>/dev/null | wc -l)
    echo "  Running Services: $RUNNING" >> "$OUTPUT_FILE"
    echo "  Failed Services:  $FAILED" >> "$OUTPUT_FILE"
    
    if [ "$FAILED" -gt 0 ]; then
        echo "" >> "$OUTPUT_FILE"
        echo "Failed Services:" >> "$OUTPUT_FILE"
        echo "---------------" >> "$OUTPUT_FILE"
        systemctl list-units --type=service --state=failed --no-pager --no-legend 2>/dev/null | \
            awk '{printf "  [-] %s\n", $1}' >> "$OUTPUT_FILE"
    fi
elif [ -f /sbin/chkconfig ] || command -v chkconfig >/dev/null 2>&1; then
    # RHEL 5.x/6.x using chkconfig
    echo "Service Status Overview (chkconfig):" >> "$OUTPUT_FILE"
    echo "------------------------------------" >> "$OUTPUT_FILE"
    chkconfig --list 2>/dev/null | grep ':on' | awk '{printf "  [+] %s\n", $1}' >> "$OUTPUT_FILE"
    
    echo "" >> "$OUTPUT_FILE"
    echo "Currently Running Processes (ps):" >> "$OUTPUT_FILE"
    echo "---------------------------------" >> "$OUTPUT_FILE"
    # Show key services
    ps aux | grep -E 'httpd|sshd|mysqld|postgres|crond|syslog|network' | grep -v grep | \
        awk '{printf "  [+] %s (PID: %s)\n", $11, $2}' >> "$OUTPUT_FILE"
    
elif command -v service >/dev/null 2>&1; then
    # Ubuntu/Debian using service command
    echo "Service Status Overview (service):" >> "$OUTPUT_FILE"
    echo "----------------------------------" >> "$OUTPUT_FILE"
    service --status-all 2>/dev/null | grep '\[ + \]' | sed 's/\[ + \]/  [+]/' >> "$OUTPUT_FILE"
else
    echo "  Unable to determine service management system." >> "$OUTPUT_FILE"
    echo "  Showing running processes:" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    ps aux | head -20 | awk 'NR>1 {printf "  %s\n", $0}' >> "$OUTPUT_FILE"
fi

# YUM/APT Repositories
print_section "3. REPOSITORY CONFIGURATION"

# Check for YUM repositories (RHEL/CentOS)
if [ -d /etc/yum.repos.d/ ]; then
    echo "YUM Repository Files in /etc/yum.repos.d/:" >> "$OUTPUT_FILE"
    echo "-------------------------------------------" >> "$OUTPUT_FILE"
    
    REPO_COUNT=$(ls -1 /etc/yum.repos.d/*.repo 2>/dev/null | wc -l)
    
    if [ "$REPO_COUNT" -gt 0 ]; then
        for repo_file in /etc/yum.repos.d/*.repo; do
            echo "" >> "$OUTPUT_FILE"
            echo "  File: $(basename "$repo_file")" >> "$OUTPUT_FILE"
            echo "  ---------------------------------------------------------------------------" >> "$OUTPUT_FILE"
            
            # Extract repository IDs and names
            grep -E '^\[.*\]' "$repo_file" | sed 's/\[/     [/' >> "$OUTPUT_FILE"
        done
        
        echo "" >> "$OUTPUT_FILE"
        echo "Total Repository Files: $REPO_COUNT" >> "$OUTPUT_FILE"
    else
        echo "  No repository files found." >> "$OUTPUT_FILE"
    fi

# Check for APT sources (Ubuntu/Debian)
elif [ -f /etc/apt/sources.list ]; then
    echo "APT Repository Configuration:" >> "$OUTPUT_FILE"
    echo "-----------------------------" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Main sources.list:" >> "$OUTPUT_FILE"
    grep -v '^#' /etc/apt/sources.list | grep -v '^$' | sed 's/^/  /' >> "$OUTPUT_FILE"
    
    if [ -d /etc/apt/sources.list.d/ ]; then
        echo "" >> "$OUTPUT_FILE"
        echo "Additional repository files:" >> "$OUTPUT_FILE"
        ls -1 /etc/apt/sources.list.d/ 2>/dev/null | sed 's/^/  /' >> "$OUTPUT_FILE"
    fi
else
    echo "  No standard repository configuration found." >> "$OUTPUT_FILE"
fi

# Disk Usage
print_section "4. DISK USAGE INFORMATION"

echo "Filesystem Usage (df -h):" >> "$OUTPUT_FILE"
echo "------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Format df output nicely - compatible with older awk versions
df -h | awk 'BEGIN {
    printf "  %-25s %8s %8s %8s %6s  %s\n", "Filesystem", "Size", "Used", "Avail", "Use%", "Mounted"
    printf "  %-25s %8s %8s %8s %6s  %s\n", "-------------------------", "--------", "--------", "--------", "------", "-------"
}
NR>1 {
    printf "  %-25s %8s %8s %8s %6s  %s\n", $1, $2, $3, $4, $5, $6
}' >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "Disk Usage Warnings:" >> "$OUTPUT_FILE"
echo "-------------------" >> "$OUTPUT_FILE"

# Check for high disk usage - compatible with older shells
HIGH_USAGE=0
df -h | tail -n +2 | while read line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    FS=$(echo "$line" | awk '{print $1}')
    MOUNT=$(echo "$line" | awk '{print $6}')
    
    # Check if USAGE is a number and >= 80
    if [ -n "$USAGE" ] && [ "$USAGE" -ge 80 ] 2>/dev/null; then
        echo "  [!] $FS is ${USAGE}% full (mounted on $MOUNT)" >> "$OUTPUT_FILE"
        HIGH_USAGE=1
    fi
done

# Check if any warnings were written
if ! grep -q "\[!\]" "$OUTPUT_FILE"; then
    echo "  All filesystems are within safe limits (below 80%)." >> "$OUTPUT_FILE"
fi

# Footer
cat >> "$OUTPUT_FILE" << 'EOF'

================================================================================
                            END OF REPORT
================================================================================
EOF

echo ""
echo "==> System report generated successfully: $OUTPUT_FILE"
echo "==> View with: cat $OUTPUT_FILE"
echo "==> Edit with: vim $OUTPUT_FILE"
echo ""
