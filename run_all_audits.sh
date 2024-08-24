#!/bin/bash

# Run all individual security audit scripts
~/security_audit/scripts/user_audit.sh
~/security_audit/scripts/file_permissions_audit.sh
~/security_audit/scripts/service_audit.sh
~/security_audit/scripts/network_security_audit.sh
~/security_audit/scripts/update_check.sh
~/security_audit/scripts/ssh_hardening.sh

echo "All security audits completed."
