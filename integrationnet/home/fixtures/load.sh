#!/usr/bin/env bash
set -e

# Bridge server must be started
while ! curl --fail -X POST http://localhost:8006/create-keypair &> /dev/null ; do
  echo "Waiting for bridge server to be available..."
  sleep 1
done

# Horizon must be started and responding to requests
while ! curl --fail http://localhost:8000 |grep protocol_version &> /dev/null ; do
  echo "Waiting for Horizon to be available..."
  sleep 1
done

# Friendbot must be started and giving the error message about an invalid request
# This is normal behavior when a parameter is missing but everything else is working
# as expected.
while ! curl http://localhost:8004 |grep reason &> /dev/null ; do
  echo "Waiting for Friendbot to be available..."
  sleep 1
done

# Only run fixtures once
if [ -f /opt/stellar/.fixtures-initialized ]; then
    echo "Fixtures already initialized"
    exit 0
fi

# Apply protocol upgrades and match current production network
# Protocol version 9
# Base reserve 0.5 XLM (5000000 stroops)
stellar-core --c "upgrades?mode=set&upgradetime=2000-01-01T00:00:00Z&protocolversion=9&basereserve=5000000"

#
# Friendbot account (used to fund other accounts)
# This is funded from the root account via stellar bridge
# SDXHNTECJ63VVROJJT3A2NVZZ4XSQY77UM76TWJL536KO34UVHFAOQZZ
#
curl --fail -X POST http://localhost:8006/payment \
    -d "amount=10000000&destination=GBH2M7PZBC6GK4Q4AQLMK3MZ4WKUJ73NYHBCW5VCYOSZTAJFB2QLRCKZ"
echo "Friendbot funded"


#
# Simple accounts funded by friendbot
#

# Purpose: basic testing account #1
# Address: GAJCCCRIRXAYEU2ATNQAFYH4E2HKLN2LCKM2VPXCTJKIBVTRSOLEGCJZ
# Seed   : SDJCZISO5M5XAUV6Y7MZJNN3JZ5BWPXDHV4GXP3MYNACVDNQRQSERXBC
curl --fail http://localhost:8004?addr=GAJCCCRIRXAYEU2ATNQAFYH4E2HKLN2LCKM2VPXCTJKIBVTRSOLEGCJZ


# Purpose: basic testing account #2
# Address: GCP6IHMHWRCF5TQ4ZP6TVIRNDZD56W42F42VHYWMVDGDAND75YGAHHBQ
# Seed   : SCEDMZ7DUEOUGRQWEXHXEXISQ2NAWI5IDXRHYWT2FHTYLIQOSUK5FX2E
curl --fail http://localhost:8004?addr=GCP6IHMHWRCF5TQ4ZP6TVIRNDZD56W42F42VHYWMVDGDAND75YGAHHBQ

# Purpose: basic testing account #3
# Address: GAPSWEVEZVAOTW6AJM26NIVBITCKXNOMGBZAOPFTFDTJGKYCIIPVI4RJ
# Seed   : SBY7ZNSKQ3CDHH34RUWVIUCMM7UEWWFTCM6ORFT5QTE77JGDFCBGXSU5
curl --fail http://localhost:8004?addr=GAPSWEVEZVAOTW6AJM26NIVBITCKXNOMGBZAOPFTFDTJGKYCIIPVI4RJ