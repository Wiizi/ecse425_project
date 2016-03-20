package assembler_main;

import assembler_main.binary_instructions.SpecificInstruction;
import assembler_main.binary_instructions.instruction_types.IInstruction;
import assembler_main.binary_instructions.instruction_types.JInstruction;
import assembler_main.binary_instructions.instruction_types.RInstruction;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Andrei-ch on 2016-03-16.
 */
public class Assembler {

    private static List<String> code, original, original_no_labels;
    private static Map<String, Integer> labels;

    /**
     * builds binary assembly from MIPS code
     *
     * @param path
     */
    public static void assemble(String path) {
        original = readFile(path);
        original = trimInstructions(original);
        original_no_labels = parseForAndRemoveLabels(original);
        code = removeSpaces(original);
        code = parseForAndRemoveLabels(code);
        List<SpecificInstruction> binary = buildInstructions(code);
        binary.forEach(Assembler::print);
    }

    /**
     * reads text from a file and returns it as a list of strings
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
                System.exit(-1);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            System.exit(-1);
        }
        return str;
    }

    /**
     * @param code
     * @return
     */
    public static List<SpecificInstruction> buildInstructions(List<String> code) {
        List<SpecificInstruction> out = new ArrayList<>();
        int line_index = 0;
        String op, original_op;
        for (String line : code) {
            op = line.substring(0, 4);
            original_op = original_no_labels.get(line_index);
            // remove all non alpha characters
            op = op.replaceAll("[^a-zA-Z\\\\s]", "");
            if (original_op.contains(op)) {
                // do nothing
            } else {
                // fix
                int index = original_op.indexOf(op.charAt(0));
                String sub = original_op.substring(index, original_op.length());
                int space_index = sub.indexOf(' ');
                space_index = (space_index > 0) ? space_index : op.length();
                op = op.substring(0, space_index);
            }
            try {
                SpecificInstruction instruction = new SpecificInstruction(op);
                if (instruction.getInstruction() instanceof RInstruction) {
                    // need: rs, rt, rd, shamt
                    String rs, rt, rd, shamt;

                    // TODO get rs, rt, rd, shamt

                    (instruction.getInstruction()).setRS(" ");
                    (instruction.getInstruction()).setRT(" ");
                    ((RInstruction)instruction.getInstruction()).setRD(" ");
                    ((RInstruction)instruction.getInstruction()).setShamt(" ");


                } else if (instruction.getInstruction() instanceof IInstruction) {
                    String rs, rt, immediate;

                    // TODO get rs, rt, immedate

                    (instruction.getInstruction()).setRS(" ");
                    (instruction.getInstruction()).setRT(" ");
                    ((IInstruction)instruction.getInstruction()).setImmediate(" ");
                } else if (instruction.getInstruction() instanceof JInstruction) {
                    String address;

                    // TODO get address

                    ((JInstruction)instruction.getInstruction()).setAddress(" ");
                }
                out.add(instruction);
            } catch (Exception e) {
                print("Compilation error at line: " + original.get(line_index));
                e.printStackTrace();
                System.exit(-1);
            }

            line_index++;
        }

        return out;
    }

    /**
     * removes commented parts and empty lines of code if such exist.
     *
     * @param in
     * @return
     */
    public static List<String> trimInstructions(List<String> in) {
        List<String> out = new ArrayList<>();
        int index;
        for (String s : in) {
            index = s.indexOf('#');
            // remove commented part if comment was found
            if (index >= 0)
                s = s.substring(0, index);
            // add only if any text is left after removing commented part
            if (s.matches(".*\\w.*"))
                out.add(s);
        }
        return out;
    }

    public static List<String> removeSpaces(List<String> in) {
        List<String> out = new ArrayList<>();
        for (String line : in) {
            // remove spaces
            line = line.replaceAll("\\s+", "");
            out.add(line);
        }
        return out;
    }

    public static List<String> parseForAndRemoveLabels(List<String> in) {
        List<String> out = new ArrayList<>();
        labels = new HashMap<String, Integer>();
        int line_index = 0;
        for (String str : in) {
            int colon_index = str.indexOf(':');
            if (colon_index > 0) {
                String label = str.substring(0, colon_index);
                if (label.contains(" "))
                    try {
                        throw new Exception("Compilation error at line: " + original.get(line_index));
                    } catch (Exception e) {
                        e.printStackTrace();
                        System.exit(-1);
                    }
                labels.put(label, line_index);
            }
            str = str.substring(colon_index + 1, str.length());
            out.add(str);
            line_index++;
        }
        return out;
    }

    public static void printCode(List<String> code) {
        int index = 0;
        for (String str : code) {
            print(index + ".\t\t" + str);
            index++;
        }
    }

    public static void print(Object o) {
        System.out.println(o);
    }
}
