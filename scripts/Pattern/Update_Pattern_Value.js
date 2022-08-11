import { resimulate_stack } from "../Stack/Stack.js";
import drawn_patterns, { set_drawn_patterns } from "./Drawn_Patterns.js";
import reorder_patterns from "./Re_Order_Patterns.js";
import sig_from_number from "./Signature_From_Number.js";

function update_pattern_value(index, value) {
    let pattern = drawn_patterns[index]
    if(!isNaN(parseFloat(value))) value = parseFloat(value)
    let patterns = [...drawn_patterns]
    pattern["outputs"][0].value = value
    if(pattern["outputs"][0].type === "number" && Number.isInteger(value) && value.toString().length <= 5) {
        pattern.str = sig_from_number(value)
    }
    set_drawn_patterns(patterns)
    reorder_patterns()
    resimulate_stack()
}

export default update_pattern_value