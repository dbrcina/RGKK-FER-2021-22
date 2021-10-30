package hr.fer.rgkk.transactions;

import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.script.Script;

public class PayToPubKeyHash extends ScriptTransaction {

    public PayToPubKeyHash(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
    }

    @Override
    public Script createLockingScript() {
        // TODO: Create Locking script
        throw new UnsupportedOperationException();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedTransaction) {
        // TODO: Create Unlocking script
        throw new UnsupportedOperationException();
    }
}
