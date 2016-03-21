import assembler_main.Assembler;

/**
 * Created by Andrei-ch on 2016-03-19.
 */
public class Driver {
    // final variables
    static final String filename_in = "bitwise.asm";
    static final String filename_out = "bitwise.txt";
    static final String path_in = "./resources/" + filename_in;
    static final String path_out = "./resources/" + filename_out;

    /**
     * run assembler
     * @param args
     */
    public static void main(String[] args) {
        Assembler.assemble(path_in, path_out);
    }
}
