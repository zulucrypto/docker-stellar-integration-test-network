## Description

Standalone single-node Stellar network with fixtures for integration testing with
Horizon.

## Quickstart

Start a docker container with port 8000 (Horizon) available:

```$bash
$ docker run -it \
    --rm \
    --name horizon-integrationnet \
    -p 8000:8000 \
    zulucrypto/stellar-integration-test-network
```

The container will begin starting and creating a new private Stellar network.

Eventually, you will see output like this:

```$bash
... lines omitted ... 
2017-10-28 22:40:47,205 INFO success: postgresql entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2017-10-28 22:40:47,205 INFO success: stellar-core entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2017-10-28 22:40:47,205 INFO success: horizon entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2017-10-28 22:40:47,205 INFO success: bridge entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2017-10-28 22:40:47,206 INFO success: fixtures entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2017-10-28 22:41:08,321 INFO exited: fixtures (exit status 0; expected)
```

`fixtures (exit status 0; expected)` indicates that fixtures have finished loading
and the private network is ready for use.

### Connecting to Horizon

Since this network uses a custom passphrase you will need to use it when signing transactions.

**Java SDK Example**
```
sdk.Network.use(new sdk.Network('Integration Test Network ; zulucrypto'))
```

## Initial network state

### Friendbot

Friendbot is funded with XLM and can be used to fund additional accounts:

```bash
curl http://localhost:8000/friendbot?addr=GAJCCCRIRXAYEU2ATNQAFYH4E2HKLN2LCKM2VPXCTJKIBVTRSOLEGCJZ
```

The network is setup with several initial accounts:

```text
Address: GAJCCCRIRXAYEU2ATNQAFYH4E2HKLN2LCKM2VPXCTJKIBVTRSOLEGCJZ
Seed   : SDJCZISO5M5XAUV6Y7MZJNN3JZ5BWPXDHV4GXP3MYNACVDNQRQSERXBC

Address: GCP6IHMHWRCF5TQ4ZP6TVIRNDZD56W42F42VHYWMVDGDAND75YGAHHBQ
Seed   : SCEDMZ7DUEOUGRQWEXHXEXISQ2NAWI5IDXRHYWT2FHTYLIQOSUK5FX2E

Address: GAPSWEVEZVAOTW6AJM26NIVBITCKXNOMGBZAOPFTFDTJGKYCIIPVI4RJ
Seed   : SBY7ZNSKQ3CDHH34RUWVIUCMM7UEWWFTCM6ORFT5QTE77JGDFCBGXSU5
```

You can use Horizon as normal:

```text
$ curl http://localhost:8000/accounts/GAPSWEVEZVAOTW6AJM26NIVBITCKXNOMGBZAOPFTFDTJGKYCIIPVI4RJ
...
  "balances": [
    {
      "balance": "10000.0000000",
      "asset_type": "native"
    }
  ],
 ...
```

## Upgrades / Network Changes

Since this is a one-node network, you can change any properties by using the `upgrades` command.

By default, the network is configured to match the stellar production network:
 * Protocol version 9
 * Base reserve 0.5 XLM
 
If you wanted to change the fee to 0.00002 XLM and the base reserve to 0.25 XLM

```bash
# Enter the container
$ docker exec -it your-container-name bash

# Run the stellar core upgrade command
$ stellar-core --c "upgrades?mode=set&upgradetime=2000-01-01T00:00:00Z&basereserve=2500000&fee=200"
```

Changes will be applied in the next ledger.

For more information on what upgrades you can set, see "upgrades" here: https://www.stellar.org/developers/stellar-core/software/commands.html#http-commands

## References

* Heavily based on https://github.com/stellar/docker-stellar-core-horizon
* This PR was very helpful for the private network portion: https://github.com/stellar/docker-stellar-core-horizon/pull/7
