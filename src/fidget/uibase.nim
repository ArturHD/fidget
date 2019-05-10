import chroma, vmath

const
  clearColor* = color(0,0,0,0)
  whiteColor* = color(1,1,1,1)
  blackColor* = color(0,0,0,1)

type

  Box* = object
    x*: float
    y*: float
    w*: float
    h*: float

  TextStyle* = object
    fontFamily*: string
    fontSize*: float
    fontWeight*: float
    lineHeight*: float
    textAlignHorizontal*: float
    textAlignVertical*:float

  BorderStyle* = object
    color*: Color
    width*: float

  Group* = ref object
    id*: string
    kind*: string
    text*: string
    placeholder*: string
    code*: string
    kids*: seq[Group]
    box*: Box
    screenBox*: Box
    fill*: Color
    transparency*: float32
    strokeWeight*: int
    stroke*: Color
    zLevel*: int
    resizeDone*: bool
    htmlDone*: bool
    textStyle*: TextStyle
    imageName*: string
    cornerRadius*: (int, int, int, int)
    wasDrawn*: bool # was group drawn or it still needs to be drawn
    editableText*: bool

  KeyState* = enum
    Empty
    Up
    Down
    Press

  MouseCursorStyle* = enum
    Default
    Pointer

  Mouse* = ref object
    state: KeyState
    pos*: Vec2
    click*: bool # mouse button just got held down
    down*: bool # mouse button is held down
    cursorStyle*: MouseCursorStyle # sets the mouse cursor icon

  Keyboard* = ref object
    state*: KeyState
    keyCode*: int
    keyString*: string
    altKey*: bool
    ctrlKey*: bool
    shiftKey*: bool
    inputFocusId*: string
    input*: string

  Perf* = object
    drawMain*: float
    numLowLevelCalls*: int

  Window* = ref object
    innerTitle*: string
    innerUrl*: string

var
  window* = Window()
  parent*: Group
  root*: Group
  prevRoot*: Group
  groupStack*: seq[Group]
  current*: Group
  scrollBox*: Box
  mouse* = Mouse()
  keyboard* = Keyboard()
  drawMain*: proc()
  perf*: Perf
  requestedFrame*: bool
  numGroups*: int
  rootUrl*: string
  popupActive*: bool
  inPopup*: bool

mouse = Mouse()
mouse.pos = Vec2()


proc setupRoot*() =
  prevRoot = root
  root = Group()
  groupStack = @[root]
  current = root
  root.id = "root"

proc use*(keyboard: Keyboard) =
  keyboard.state = Empty
  keyboard.keyCode = 0
  keyboard.keyString = ""
  keyboard.altKey = false
  keyboard.ctrlKey = false
  keyboard.shiftKey = false


proc use*(mouse: Mouse) =
  mouse.click = false

