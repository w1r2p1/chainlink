# Walkthrough

## Setup

### [Install Dependencies](https://github.com/smartcontractkit/chainlink#install)

For this walkthrough, you will need:

- [Go](https://golang.org/doc/install#install)
- [dep](https://github.com/golang/dep#installation)
- [Node](https://nodejs.org/en/download/package-manager/)
- [Yarn](https://yarnpkg.com/lang/en/docs/install/#mac-stable)
- [Docker](https://www.docker.com/get-started)
- [direnv](https://direnv.net/) (optional)

If you're on a mac with [Homebrew](https://brew.sh/), you can run:

`brew install go dep node yarn docker direnv`

### Install Chainlink


```bash
go get -d github.com/smartcontractkit/chainlink
cd $GOPATH/src/github.com/smartcontractkit/chainlink
make install
chainlink help
```

## Run

Spin up a local Ethereum node:

```bash
./internal/bin/devnet
```

In a separate window:

```bash
CHAINLINK_DEV=true chainlink node
... login ...
> [INFO]  Link Balance for 0x6e1d1f9f1C640D31E15ddc0e5a2FD200830e58A1
```



## Set up your LINK and Oracle contracts
Move to the solidity directory: `cd solidity/`

```
./fund_dev_wallet 0x6e1d1f9f1C640D31E15ddc0e5a2FD200830e58A1
```

Deploy the LINK token:

```
./deploy LinkToken.sol
> LinkToken.sol successfully deployed: 0x20fE562d797A42Dcb3399062AE9546cd06f63280
```

Deploy an Oracle:

```
./deploy Oracle.sol 0x20fE562d797A42Dcb3399062AE9546cd06f63280
> Oracle.sol successfully deployed: 0x9af9c91E1f5E22D1a7eA8E8AF3CB3b3f858a619d
```
Transfer Oracle ownership to your node


```
./transfer_owner 0x9af9c91E1f5E22D1a7eA8E8AF3CB3b3f858a619d 0x6e1d1f9f1C640D31E15ddc0e5a2FD200830e58A1
> ownership of 0x9af9c91E1f5E22D1a7eA8E8AF3CB3b3f858a619d transferred to 0x6e1d1f9f1C640D31E15ddc0e5a2FD200830e58A1
```

### Create your first job spec:

Log into your node at [http://localhost:6688](http://localhost:6688), and then click the `Create Job` button in the top right of the dashboard.

Edit the following JSON so that it includes your Oracle address for the initiators address field:
```
{
  "initiators": [{
      "type": "runlog",
      "params": {"address": "0x9af9c91E1f5E22D1a7eA8E8AF3CB3b3f858a619d"}
  }],
  "tasks": [
    {"type": "httpget"},
    {"type": "jsonparse"},
    {"type": "ethbytes32"},
    {"type": "ethtx"}
  ]
}
```

Once it has successfully created, grab your Job Spec ID, it should look be hex again, but shorter: `8452ff74ebe745e0ab9f7edddb16ecb0 `


# Use your oracle:
Deploy a data consumer:

```
./deploy BasicConsumer.sol 0x20fE562d797A42Dcb3399062AE9546cd06f63280 0x9af9c91E1f5E22D1a7eA8E8AF3CB3b3f858a619d 8452ff74ebe745e0ab9f7edddb16ecb0
> BasicConsumer.sol successfully deployed: 0x55ad1706ca8cf0ac593b918c105944487d0737b2
```

Request an Ethereum price:

```
./update_eth_price 0x55ad1706ca8cf0ac593b918c105944487d0737b2
> FAILED!!!
```

Check price on contract:

```
./view_eth_price 0x55ad1706ca8cf0ac593b918c105944487d0737b2
> No price listed
```

Your Consumer needs LINK. Transfer some LINK:

```
./transfer_tokens 0x20fE562d797A42Dcb3399062AE9546cd06f63280 0x55ad1706ca8cf0ac593b918c105944487d0737b2
> 1000 LINK successfully sent to 0x55ad1706ca8cf0ac593b918c105944487d0737b2
```

Request an Ethereum price again:

```
./update_eth_price 0x55ad1706ca8cf0ac593b918c105944487d0737b2
> price successfully requested
```

Check price on contract:

```
./view_eth_price 0x55ad1706ca8cf0ac593b918c105944487d0737b2
> current ETH price: 230.04
```
