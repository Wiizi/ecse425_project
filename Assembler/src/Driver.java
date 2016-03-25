import assembler_main.Assembler;
import assembler_main.binary_instructions.toolset.Tools;

/**
 * Created by Andrei-ch on 2016-03-19.
 */
public class Driver {
    // final variables
    static final String filename_in = "addi.asm";
    static final String path_in = "./resources/" + filename_in;

    /**
     * run assembler
     * @param args
     */
    public static void main(String[] args) {
//        String read_from = args[0];
        String write_to = path_in.replace(".asm", ".dat");
        Assembler.assemble(path_in, write_to);
    }
}
