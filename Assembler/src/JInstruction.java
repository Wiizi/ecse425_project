/**
 * Created by Andrei-ch on 2016-03-18.
 */
public class JInstruction extends BinaryInstruction {

    public JInstruction() {
        super();
    }

    public void setAddress(String str) {
        this.setInstruction(str, 25, 0);
    }

    @Override
    public void setRS(String str) {
        // nothing to do
    }

    @Override
    public void setRT(String str) {
        // nothing to do
    }
}