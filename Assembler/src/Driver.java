import assembler_main.Assembler;

/**
 * Created by Andrei-ch on 2016-03-19.
 */
public class Driver {
    // final variables
    static final String filename = "bitwise.asm";
    static final String path = "./resources/" + filename;

    /**
     * run assembler
     * @param args
     */
    public static void main(String[] args) {
        Assembler.assemble(path);
    }
}
