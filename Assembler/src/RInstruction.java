/**
 * Created by Andrei-ch on 2016-03-18.
 */
public class RInstruction extends BinaryInstruction {

    public RInstruction() {
        super();
    }

    public void setRD(String str) {
        this.setInstruction(str, 15, 11);
    }

    public void setShamt(String str) {
        this.setInstruction(str, 10, 6);
    }

    public void setFunct(String str) {
        this.setInstruction(str, 5, 0);
    }
}