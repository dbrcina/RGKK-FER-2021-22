package hr.fer.rgkk.transactions;

import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.script.Script;
import org.bitcoinj.script.ScriptBuilder;

import static org.bitcoinj.script.ScriptOpCodes.*;

public class LogicalEquivalenceTransaction extends ScriptTransaction {

    public LogicalEquivalenceTransaction(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
    }

    @Override
    public Script createLockingScript() {
        return new ScriptBuilder()
                .op(OP_2DUP)
                .number(0)
                .number(2)
                .op(OP_WITHIN)
                .number(1)
                .op(OP_EQUALVERIFY)
                .number(0)
                .number(2)
                .op(OP_WITHIN)
                .number(1)
                .op(OP_EQUALVERIFY)
                .op(OP_EQUAL)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedScript) {
        long x = 1;
        long y = 1;
        return new ScriptBuilder()
                .number(x)
                .number(y)
                .build();
    }

}
