package assembler_main.binary_instructions;

import assembler_main.binary_instructions.instruction_types.GenericInstruction;
import assembler_main.binary_instructions.instruction_types.IInstruction;
import assembler_main.binary_instructions.instruction_types.JInstruction;
import assembler_main.binary_instructions.instruction_types.RInstruction;
import assembler_main.binary_instructions.toolset.InstructionList;

/**
 * Created by Andrei-ch on 2016-03-19.
 */
public class SpecificInstruction {

    protected static InstructionList instrList = null; // singleton

    protected GenericInstruction instruction;

    public SpecificInstruction(String str){
        if (instrList == null)
            instrList = new InstructionList();

        String type = instrList.get(str);
        if (type.equals("R")) {
            instruction = new RInstruction(str);
        }
        else if (type.equals("I")) {
            instruction = new IInstruction(str);
        }
        else if (type.equals("J")) {
            instruction = new JInstruction(str);
        }
    }

    public String toString(){
        return instruction.toString();
    }
}
