/**
 * Created by Andrei-ch on 2016-03-18.
 */
public class IInstruction extends BinaryInstruction {

    public IInstruction() {
        super();
    }

    public void setImmediate(String str) {
        this.setInstruction(str, 15, 0);
    }
}