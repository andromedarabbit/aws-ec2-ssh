#!/bin/bash -e

if grep -q '#AuthorizedKeysCommand none' "$SSHD_CONFIG_FILE"; then
  sed -i "s:#AuthorizedKeysCommand none:AuthorizedKeysCommand ${AUTHORIZED_KEYS_COMMAND_FILE}:g" "$SSHD_CONFIG_FILE"
else
  if ! grep -q "AuthorizedKeysCommand ${AUTHORIZED_KEYS_COMMAND_FILE}" "$SSHD_CONFIG_FILE"; then
    echo "" >> "$SSHD_CONFIG_FILE"
    echo "AuthorizedKeysCommand ${AUTHORIZED_KEYS_COMMAND_FILE}" >> "$SSHD_CONFIG_FILE"
  fi
fi

OS_ID=$(cat /etc/os-release | egrep '^ID=' | awk -F "=" '/ID=/ {print $2}')
if [[ "${OS_ID}" == "coreos" ]]; then
  if grep -q '#AuthorizedKeysCommandUser nobody' "$SSHD_CONFIG_FILE"; then
      sed -i "s:#AuthorizedKeysCommandUser nobody:AuthorizedKeysCommandUser root:g" "$SSHD_CONFIG_FILE"
  else
      if ! grep -q 'AuthorizedKeysCommandUser nobody' "$SSHD_CONFIG_FILE"; then
        echo "" >> "$SSHD_CONFIG_FILE"
        echo "AuthorizedKeysCommandUser root" >> "$SSHD_CONFIG_FILE"
      fi
  fi
else
  if grep -q '#AuthorizedKeysCommandUser nobody' "$SSHD_CONFIG_FILE"; then
    sed -i "s:#AuthorizedKeysCommandUser nobody:AuthorizedKeysCommandUser nobody:g" "$SSHD_CONFIG_FILE"
  else
    if ! grep -q 'AuthorizedKeysCommandUser nobody' "$SSHD_CONFIG_FILE"; then
      echo "" >> "$SSHD_CONFIG_FILE"
      echo "AuthorizedKeysCommandUser nobody" >> "$SSHD_CONFIG_FILE"
    fi
  fi
fi