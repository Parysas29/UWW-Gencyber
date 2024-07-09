import orca.settings
import orca.input_event
from orca.orca_keybindings import KeyBindings

def loadNvdaKeyBindings(script=None):
    bindings = KeyBindings()
    
    # Example: Map NVDA 'read current line' (NVDA+UpArrow) to Orca's 'read current line' (Orca+UpArrow)
    bindings.add(orca.input_event.KeyBinding(
        orca.input_event.KeyEvent(
            orca.input_event.UP, 
            modifiers=(orca.input_event.MODIFIER_ORCA,)),
        orca.commands.sayLine))

    bindings.add(orca.input_event.KeyBinding(
        orca.input_event.KeyEvent(
            orca.input_event.DOWN, 
            modifiers=(orca.input_event.MODIFIER_ORCA,)),
        orca.commands.sayNextLine))

    bindings.add(orca.input_event.KeyBinding(
    orca.input_event.KeyEvent(
        orca.input_event.UP, 
        modifiers=(orca.input_event.MODIFIER_ORCA,)),
    orca.commands.sayPreviousLine))

    bindings.add(orca.input_event.KeyBinding(
    orca.input_event.KeyEvent(
        orca.input_event.KP_Subtract, 
        modifiers=(orca.input_event.MODIFIER_ORCA,)),
    orca.commands.sayWord))

    bindings.add(orca.input_event.KeyBinding(
    orca.input_event.KeyEvent(
        orca.input_event.KP_Add, 
        modifiers=(orca.input_event.MODIFIER_ORCA,)),
    orca.commands.sayNextWord))

    # Add more key bindings here following the same pattern
    
    return bindings

orca.settings.keyBindings = loadNvdaKeyBindings()
