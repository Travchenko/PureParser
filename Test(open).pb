﻿EnableExplicit

XIncludeFile "Transformation.pbi"

Procedure OpenPBObject(Type$, X=0,Y=0,Width=0,Height=0, Flag=0, Caption$="", Param1=0, Param2=0, Param3=0)
  Protected ID
  Static ParentID, Parent
  
  Select Type$
    Case "OpenWindow"          : ID = OpenWindow          (#PB_Any, X,Y,Width,Height, Caption$, Flag|#PB_Window_SizeGadget) 
    Case "ButtonGadget"        : ID = ButtonGadget        (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "StringGadget"        : ID = StringGadget        (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "TextGadget"          : ID = TextGadget          (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "CheckBoxGadget"      : ID = CheckBoxGadget      (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "OptionGadget"        : ID = OptionGadget        (#PB_Any, X,Y,Width,Height, Caption$)
    Case "ListViewGadget"      : ID = ListViewGadget      (#PB_Any, X,Y,Width,Height, Flag)
    Case "FrameGadget"         : ID = FrameGadget         (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ComboBoxGadget"      : ID = ComboBoxGadget      (#PB_Any, X,Y,Width,Height, Flag)
    Case "ImageGadget"         : ID = ImageGadget         (#PB_Any, X,Y,Width,Height, Param1,Flag)
    Case "HyperLinkGadget"     : ID = HyperLinkGadget     (#PB_Any, X,Y,Width,Height, Caption$,Param1,Flag)
    Case "ContainerGadget"     : ID = ContainerGadget     (#PB_Any, X,Y,Width,Height, Flag)
    Case "ListIconGadget"      : ID = ListIconGadget      (#PB_Any, X,Y,Width,Height, Caption$, Param1, Flag)
    Case "IPAddressGadget"     : ID = IPAddressGadget     (#PB_Any, X,Y,Width,Height)
    Case "ProgressBarGadget"   : ID = ProgressBarGadget   (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "ScrollBarGadget"     : ID = ScrollBarGadget     (#PB_Any, X,Y,Width,Height, Param1, Param2, Param3, Flag)
    Case "ScrollAreaGadget"    : ID = ScrollAreaGadget    (#PB_Any, X,Y,Width,Height, Param1, Param2, Param3, Flag) 
    Case "TrackBarGadget"      : ID = TrackBarGadget      (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "WebGadget"           : ID = WebGadget           (#PB_Any, X,Y,Width,Height, Caption$)
    Case "ButtonImageGadget"   : ID = ButtonImageGadget   (#PB_Any, X,Y,Width,Height, Param1, Flag)
    Case "CalendarGadget"      : ID = CalendarGadget      (#PB_Any, X,Y,Width,Height, Param1, Flag)
    Case "DateGadget"          : ID = DateGadget          (#PB_Any, X,Y,Width,Height, Caption$, Param1, Flag)
    Case "EditorGadget"        : ID = EditorGadget        (#PB_Any, X,Y,Width,Height, Flag)
    Case "ExplorerListGadget"  : ID = ExplorerListGadget  (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ExplorerTreeGadget"  : ID = ExplorerTreeGadget  (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ExplorerComboGadget" : ID = ExplorerComboGadget (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "SpinGadget"          : ID = SpinGadget          (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "TreeGadget"          : ID = TreeGadget          (#PB_Any, X,Y,Width,Height, Flag)
    Case "PanelGadget"         : ID = PanelGadget         (#PB_Any, X,Y,Width,Height) 
    Case "SplitterGadget"      
      If IsGadget(Param1) And IsGadget(Param2)
        ID = SplitterGadget      (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
      EndIf
    Case "MDIGadget"          
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ID = MDIGadget           (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag) 
      CompilerEndIf
    Case "ScintillaGadget"     : ID = ScintillaGadget     (#PB_Any, X,Y,Width,Height, Param1)
    Case "ShortcutGadget"      : ID = ShortcutGadget      (#PB_Any, X,Y,Width,Height, Param1)
    Case "CanvasGadget"        : ID = CanvasGadget        (#PB_Any, X,Y,Width,Height, Flag)
      
    Case "CloseGadgetList"     : CloseGadgetList()
    Case "UseGadgetList"       : UseGadgetList( ParentID )
    Case "AddGadgetItem"       
;       Debug GadgetType(Parent)
;       OpenGadgetList( Parent, Param1 )
      AddGadgetItem( Parent, #PB_Any, Caption$, Param1, Flag)
    Case "OpenGadgetList"      : OpenGadgetList( Parent, Param1 )
  EndSelect
  
  Select Type$
    Case "OpenWindow"          
      Parent = ID
      ParentID = WindowID(ID)
    Case "ContainerGadget", "ScrollAreaGadget", "PanelGadget"
      Parent = ID
      ParentID = GadgetID(ID)
  EndSelect
  
  If IsGadget(ID)
    ;OpenGadgetList(Parent)
    Transformation::Enable(ID, 5)
    ;CloseGadgetList()
  EndIf
  
  ProcedureReturn ID
EndProcedure

UsePNGImageDecoder()
LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png")

Define Window_0 = OpenPBObject("OpenWindow", 0, 0, 310, 325, #PB_Window_SystemMenu)
OpenPBObject("ContainerGadget", 10, 50, 290, 265, #PB_Container_Flat)
OpenPBObject("ButtonGadget", 10, 10, 85, 35, 0, "Button")
OpenPBObject("ContainerGadget", 10, 55, 265, 200, #PB_Container_Single)
OpenPBObject("StringGadget", 10, 10, 150, 35)
OpenPBObject("PanelGadget", 10, 55, 245, 140)
OpenPBObject("AddGadgetItem", 0,0,0,0,0, "Item_0")
OpenPBObject("AddGadgetItem", 0,0,0,0,0, "Item_1", ImageID(0))
OpenPBObject("ButtonGadget", -10, 10, 85, 35, 0, "Button")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("ButtonGadget", 190, 10, 85, 35, 0, "Button")
OpenPBObject("CloseGadgetList")

OpenPBObject("OpenGadgetList", 0,0,0,0,0, "", 0)
OpenPBObject("ButtonGadget", -10, 30, 85, 35, 0, "Button")
OpenPBObject("CloseGadgetList")

OpenPBObject("ButtonGadget", 110, 10, 85, 35, 0, "Button")

While IsWindow( Window_0 )
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow 
      CloseWindow( EventWindow() )
  EndSelect
Wend