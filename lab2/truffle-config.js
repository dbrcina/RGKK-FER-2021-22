module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    networks: {
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*",
            gas: 100000000
        }
    },
    compilers: {
        solc: {
            version: "^0.8.0"
        }
    }
};
