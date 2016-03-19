/**
 * Created by Andrei-ch on 2016-03-18.
 */
public class BinaryInstruction {

    protected static final int INSTRUCTION_LENGTH = 32;

    // instruction format: [b31 b30 b29 ... b1 b0]
    protected char[] instruction;

    public BinaryInstruction() {
        this.instruction = new char[INSTRUCTION_LENGTH];
    }

    public void setInstruction(String str, int i, int j) {
        i = remap(i);
        j = remap(j);
        for (int k = i; k < j; k++) {
            this.instruction[k] = str.charAt(k - i);
        }
    }

    public void setOpCode(String str) {
        setInstruction(str, 6, 0);
    }

    public void setRS(String str) {
        this.setInstruction(str, 25, 21);
    }

    public void setRT(String str) {
        this.setInstruction(str, 20, 16);
    }

    public char[] getInstruction() {
        return this.instruction;
    }

    public int remap(int i) {
        return INSTRUCTION_LENGTH - 1 - i;
    }
}
