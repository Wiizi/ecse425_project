import assembler_main.Assembler;

/**
 * Created by Andrei-ch on 2016-03-19.
 */
public class Driver {

    static final String filename = "bitwise.asm";
    static final String path = "./resources/" + filename;

    public static void main(String[] args) {
        Assembler assembler = new Assembler(path);
    }

}
