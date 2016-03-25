import assembler_main.Assembler;
import assembler_main.binary_instructions.toolset.Tools;

/**
 * Created by Andrei-ch on 2016-03-19.
 */
public class Driver {

    /**
     * run assembler
     * @param args
     */
    public static void main(String[] args) {
        String read_from = args[0];
        String write_to = read_from.replace(".asm", ".dat");
        Assembler.assemble(read_from, write_to);
    }
}
