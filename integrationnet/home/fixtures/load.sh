#!/usr/bin/env bash
set -e

# Bridge server must be started
while ! curl --fail -X POST http://localhost:8006/create-keypair &> /dev/null ; do
  echo "Waiting for bridge server to be available..."
  sleep 1
done

# Only run fixtures once
if [ -f /opt/stellar/.fixtures-initialized ]; then
    echo "Fixtures already initialized"
    exit 0
fi

#
# Friendbot account (used to fund other accounts)
# This is funded from the root account via stellar bridge
#
curl --fail -X POST http://localhost:8006/payment \
    -d "amount=10000000&destination=GCRJYNHOL62AZNGZQCLAVP4WW26JD5FLG2PPIKC5T3YR42NQJJJ7LK4Q"
echo "Friendbot funded"


#
# Simple accounts funded by friendbot
#

# Purpose: basic testing account #1
# Address: GAJCCCRIRXAYEU2ATNQAFYH4E2HKLN2LCKM2VPXCTJKIBVTRSOLEGCJZ
# Seed   : SDJCZISO5M5XAUV6Y7MZJNN3JZ5BWPXDHV4GXP3MYNACVDNQRQSERXBC
curl --fail http://localhost:8000/friendbot?addr=GAJCCCRIRXAYEU2ATNQAFYH4E2HKLN2LCKM2VPXCTJKIBVTRSOLEGCJZ


# Purpose: basic testing account #2
# Address: GCP6IHMHWRCF5TQ4ZP6TVIRNDZD56W42F42VHYWMVDGDAND75YGAHHBQ
# Seed   : SCEDMZ7DUEOUGRQWEXHXEXISQ2NAWI5IDXRHYWT2FHTYLIQOSUK5FX2E
curl --fail http://localhost:8000/friendbot?addr=GCP6IHMHWRCF5TQ4ZP6TVIRNDZD56W42F42VHYWMVDGDAND75YGAHHBQ

# Purpose: basic testing account #3
# Address: GAPSWEVEZVAOTW6AJM26NIVBITCKXNOMGBZAOPFTFDTJGKYCIIPVI4RJ
# Seed   : SBY7ZNSKQ3CDHH34RUWVIUCMM7UEWWFTCM6ORFT5QTE77JGDFCBGXSU5
curl --fail http://localhost:8000/friendbot?addr=GAPSWEVEZVAOTW6AJM26NIVBITCKXNOMGBZAOPFTFDTJGKYCIIPVI4RJ