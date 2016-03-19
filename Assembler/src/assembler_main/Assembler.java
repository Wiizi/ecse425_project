package assembler_main;

import assembler_main.binary_instructions.SpecificInstruction;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Andrei-ch on 2016-03-16.
 */
public class Assembler {

    public Assembler(String path){
        List<String> code = readFile(path);

        code = removeCommentedAndEmptyLines(code);

        // TODO

        printCode(code);
    }

    /**
     * reads text from a file and returns it as a string
     *
     * @param filename
     * @return
     */
    public static List<String> readFile(String filename) {
        BufferedReader br;
        List<String> str = new ArrayList<>();
        try {
            br = new BufferedReader(new FileReader(filename));
            try {
                String x;
                while ((x = br.readLine()) != null) {
                    // add every line to a list
                    str.add(x);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return str;
    }

    /**
     * removes commented parts and empty lines of code if such exist (MIPS syntax)
     *
     * @param in
     * @return
     */
    public static List<String> removeCommentedAndEmptyLines(List<String> in) {
        List<String> out = new ArrayList<>();
        String s;
        int index;
        for (int i = 0; i < in.size(); i++) {
            s = in.get(i);
            index = s.indexOf('#');
            // remove commented part if commend found
            if (index >= 0 && index < s.length())
                s = s.substring(0, index);
            // add only if any text is left after removing commented part
            if (s.matches(".*\\w.*"))
                out.add(s);
        }
        return out;
    }

    public static void printCode(List<String> code) {
        code.forEach(Assembler::print);
    }

    public static void print(Object o) {
        System.out.println(o);
    }
}
