﻿CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "Flag.pbi"
  XIncludeFile "Hide.pbi"
  XIncludeFile "Disable.pbi"

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/include"
  IncludeFile "fixme(mac).pbi"
CompilerEndIf

CompilerEndIf

;-
;- Module (Properties)
DeclareModule Properties
  EnableExplicit
  
  CompilerIf Defined(fixme, #PB_Module)
    ;Macro PB(Function) : Function : EndMacro
    UseModule fixme
  CompilerEndIf
  
  Structure PropertiesStruct
    Gadget.i
    Object.i
    CheckGadget.i
    CheckWindow.i
    
    Flag$
    Class$
    
    Tree.i
    Spin.i
    Button.i
    String.i
    CheckBox.i
    ComboBox.i
    TreeWindow.i
    
    ButtonImage.i
    ItemHeight.i
    GadgetType.i
    LinePos.i
    Text.S
    Info.S
    Str.S
    Int.i
    
    Font.i
    Seperator.i
    Help$
  EndStructure
  
  Global NewList Properties.PropertiesStruct()
  
  Declare.q GetPBFlag(Flags$)
  
  Declare$ GetPBFlags( Type=#PB_GadgetType_Unknown )
  Declare$ Help(Gadget)
  
  Declare Init( Object, Class$="", Flag$="" )
  Declare Change(gadget, Object, Class$="", Flag$="")
  
  Declare SetCheckedText(Gadget, Text$)
  Declare$ GetCheckedText(Gadget)
  Declare Size( Width, Height )
  Declare AddItem( Gadget, Text.S, GadgetType)
  Declare Gadget( Gadget, Width, Height, LinePos = 75 )
EndDeclareModule

Module Properties
  Declare CallBack()
  
  Macro Clip(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Define ___ClipMacroGadgetHeight___ = GadgetHeight( Gadget )
        ; SetWindowLongPtr_(GadgetID( Gadget ),#GWL_STYLE,GetWindowLongPtr_(GadgetID( Gadget ),#GWL_STYLE) | #BS_MULTILINE)
        SetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
        If ___ClipMacroGadgetHeight___ And GadgetType( Gadget ) = #PB_GadgetType_ComboBox
          ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, ___ClipMacroGadgetHeight___ )
        EndIf
        SetWindowPos_( GadgetID( Gadget ), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    CompilerEndSelect
  EndMacro
  
  Global LineGadget =- 1
  
  ;-
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      
      #G_TYPE_STRING = 64
      
      ImportC ""
        gtk_widget_get_visible(*widget.GtkWidget)
        gtk_widget_get_sensitive (*widget.GtkWidget)
;         g_object_get_Properties(*widget.GtkWidget, Properties.p-utf8, *gval)
      EndImport
      
  CompilerEndSelect
  
  
  Macro GetWindowFlag(_window_)
    Flag::GetWindow(_window_)
  EndMacro
  
  Macro SetWindowFlag(_window_, Flag)
    Flag::SetWindow(_window_, Flag)
  EndMacro
  
  Macro RemoveWindowFlag(_window_, Flag)
    Flag::RemoveWindow(_window_, Flag)
  EndMacro
  
  Macro GetGadgetFlag(_gadget_)
    Flag::GetGadget(_gadget_)
  EndMacro
  
  Macro SetGadgetFlag(_gadget_, Flag)
    Flag::SetGadget(_gadget_, Flag)
  EndMacro
  
  Macro RemoveGadgetFlag(_gadget_, Flag)
    Flag::RemoveGadget(_gadget_, Flag)
  EndMacro
  
  Macro IsHideGadget(_gadget_) ;Returns TRUE is gadget hide
    Hide::Gadget(_gadget_)
  EndMacro
  
  Macro IsDisableGadget(_gadget_) ;Returns TRUE is gadget disabled
    Disable::Gadget(_gadget_)
  EndMacro
  
  Macro IsHideWindow(_window_) ;Returns TRUE is window hide
    Hide::Window(_window_)
  EndMacro
  
  Macro IsDisableWindow(_window_) ;Returns TRUE is window disabled
    Disable::Window(_window_)
  EndMacro
  
  ;-
  Procedure$ GetPBFlagString( Gadget )
    Protected Flag.q = GetGadgetFlag(Gadget)
    
    ;
    
;     ProcedureReturn Flag
  EndProcedure
      
  Procedure$ GetPBFlags( Type=#PB_GadgetType_Unknown ) ; 
    Protected Flags.S
    
    Select Type
      Case #PB_GadgetType_Unknown        
        ;{- Ok
        Flags.S = "#PB_Window_TitleBar|"+
                  "#PB_Window_BorderLess|"+
                  "#PB_Window_SystemMenu|"+
                  "#PB_Window_MaximizeGadget|"+
                  "#PB_Window_MinimizeGadget|"+
                  "#PB_Window_ScreenCentered|"+
                  "#PB_Window_SizeGadget|"+
                  "#PB_Window_WindowCentered|"+
                  "#PB_Window_Tool|"+
                  "#PB_Window_Normal|"+
                  "#PB_Window_Minimize|"+
                  "#PB_Window_Maximize|"+
                  "#PB_Window_Invisible|"+
                  "#PB_Window_NoActivate|"+
                  "#PB_Window_NoGadgets|"
        ;}
        
      Case #PB_GadgetType_Button         
        ;{- Ok
        Flags.S = "#PB_Button_MultiLine|"+
                  "#PB_Button_Default|"+
                  "#PB_Button_Toggle|"+
                  "#PB_Button_Left|"+
                  "#PB_Button_Right"
        ;}
        
      Case #PB_GadgetType_String         
        ;{- Ok
        Flags.S = "#PB_String_BorderLess|"+
                  "#PB_String_Numeric|"+
                  "#PB_String_Password|"+
                  "#PB_String_ReadOnly|"+
                  "#PB_String_LowerCase|"+
                  "#PB_String_UpperCase"
        
        ;}
        
      Case #PB_GadgetType_Text           
        ;{- Ok
        Flags.S = "#PB_Text_Center|"+
                  "#PB_Text_Right|"+
                  "#PB_Text_Border"
        ;}
        
      Case #PB_GadgetType_CheckBox       
        ;{- Ok
        Flags.S = "#PB_CheckBox_Right|"+
                  "#PB_CheckBox_Center|"+
                  "#PB_CheckBox_ThreeState"
        ;}
        
      Case #PB_GadgetType_Option         
        Flags.S = ""
        
      Case #PB_GadgetType_ListView       
        ;{- Ok
        Flags.S = "#PB_ListView_Multiselect|"+
                  "#PB_ListView_ClickSelect"
        ;}
        
      Case #PB_GadgetType_Frame          
        ;{- Ok
        Flags.S = "#PB_Frame_Single|"+
                  "#PB_Frame_Double|"+
                  "#PB_Frame_Flat"
        ;}
        
      Case #PB_GadgetType_ComboBox       
        ;{- Ok
        Flags.S = "#PB_ComboBox_Editable|"+
                  "#PB_ComboBox_LowerCase|"+
                  "#PB_ComboBox_UpperCase|"+
                  "#PB_ComboBox_Image"
        ;}
        
      Case #PB_GadgetType_Image          
        ;{- Ok
        Flags.S = "#PB_Image_Border|"+
                  "#PB_Image_Raised"
        ;}
        
      Case #PB_GadgetType_HyperLink      
        ;{- Ok
        Flags.S = "#PB_Hyperlink_Underline"
        ;}
        
      Case #PB_GadgetType_Container      
        ;{- Ok
        Flags.S = "#PB_Container_BorderLess|"+
                  "#PB_Container_Flat|"+
                  "#PB_Container_Raised|"+
                  "#PB_Container_Single|"+
                  "#PB_Container_Double"
        ;}
        
      Case #PB_GadgetType_ListIcon       
        ;{- Ok
        Flags.S = "#PB_ListIcon_CheckBoxes|"+
                  "#PB_ListIcon_ThreeState|"+
                  "#PB_ListIcon_MultiSelect|"+
                  "#PB_ListIcon_GridLines|"+
                  "#PB_ListIcon_FullRowSelect|"+
                  "#PB_ListIcon_HeaderDragDrop|"+
                  "#PB_ListIcon_AlwaysShowSelection"
        ;}
        
      Case #PB_GadgetType_IPAddress      
        Flags.S = ""
        
      Case #PB_GadgetType_ProgressBar    
        ;{- Ok
        Flags.S = "#PB_ProgressBar_Smooth|"+
                  "#PB_ProgressBar_Vertical"
        ;}
        
      Case #PB_GadgetType_ScrollBar      
        ;{- Ok
        Flags.S = "#PB_ScrollBar_Vertical"
        ;}
        
      Case #PB_GadgetType_ScrollArea     
        ;{- Ok
        Flags.S = "#PB_ScrollArea_Flat|"+
                  "#PB_ScrollArea_Raised|"+
                  "#PB_ScrollArea_Single|"+
                  "#PB_ScrollArea_BorderLess|"+
                  "#PB_ScrollArea_Center"
        ;}
        
      Case #PB_GadgetType_TrackBar       
        ;{- Ok
        Flags.S = "#PB_TrackBar_Ticks|"+
                  "#PB_TrackBar_Vertical"
        ;}
        
      Case #PB_GadgetType_Web            
        Flags.S = ""
        
      Case #PB_GadgetType_ButtonImage    
        ;{- Ok
        Flags.S = "#PB_Button_Toggle"
        ;}
        
      Case #PB_GadgetType_Calendar       
        ;{- Ok
        Flags.S = "#PB_Calendar_Borderless"
        ;}
        
      Case #PB_GadgetType_Date           
        ;{- Ok
        Flags.S = "#PB_Date_UpDown"
        ;}
        
      Case #PB_GadgetType_Editor         
        ;{- Ok
        Flags.S = "#PB_Editor_ReadOnly|"+
                  "#PB_Editor_WordWrap"
        ;}
        
      Case #PB_GadgetType_ExplorerList   
        ;{- Ok
        Flags.S = "#PB_Explorer_BorderLess|"+
                  "#PB_Explorer_AlwaysShowSelection|"+
                  "#PB_Explorer_MultiSelect|"+
                  "#PB_Explorer_GridLines|"+
                  "#PB_Explorer_HeaderDragDrop|"+
                  "#PB_Explorer_FullRowSelect|"+
                  "#PB_Explorer_NoFiles|"+
                  "#PB_Explorer_NoFolders|"+
                  "#PB_Explorer_NoParentFolder|"+
                  "#PB_Explorer_NoDirectoryChange|"+
                  "#PB_Explorer_NoDriveRequester|"+
                  "#PB_Explorer_NoSort|"+
                  "#PB_Explorer_NoMyDocuments|"+
                  "#PB_Explorer_AutoSort|"+
                  "#PB_Explorer_HiddenFiles"
        ;}
        
      Case #PB_GadgetType_ExplorerTree   
        Flags.S = ""
        
      Case #PB_GadgetType_ExplorerCombo  
        Flags.S = ""
        
      Case #PB_GadgetType_Spin           
        Flags.S = ""
        
      Case #PB_GadgetType_Tree           
        ;{- Ok
        Flags.S = "#PB_Tree_AlwaysShowSelection|"+
                  "#PB_Tree_NoLines|"+
                  "#PB_Tree_NoButtons|"+
                  "#PB_Tree_CheckBoxes|"+
                  "#PB_Tree_ThreeState"
        ;}
        
      Case #PB_GadgetType_Panel          
        Flags.S = ""
        
      Case #PB_GadgetType_Splitter       
        ;{- Ok
        Flags.S = "#PB_Splitter_Vertical|"+
                  "#PB_Splitter_Separator|"+
                  "#PB_Splitter_FirstFixed|"+
                  "#PB_Splitter_SecondFixed" 
        ;}
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Case #PB_GadgetType_MDI           
          Flags.S = ""
        CompilerEndIf
        
      Case #PB_GadgetType_Scintilla      
        Flags.S = ""
        
      Case #PB_GadgetType_Shortcut       
        Flags.S = ""
        
      Case #PB_GadgetType_Canvas 
        ;{- Ok
        Flags.S = "#PB_Canvas_Border|"+
                  "#PB_Canvas_Container|"+
                  "#PB_Canvas_ClipMouse|"+
                  "#PB_Canvas_Keyboard|"+
                  "#PB_Canvas_DrawFocus"
        ;}
        
    EndSelect
    
    ProcedureReturn Flags.S
  EndProcedure
  
  Procedure.q GetPBFlag(Flags$)
    Protected i, Flag.q
    
    If Flags$
      For I = 0 To CountString(Flags$,"|")
        
        Select Trim(StringField(Flags$,(I+1),"|"))
            ; window
          Case "#PB_Window_BorderLess"              : Flag = Flag | #PB_Window_BorderLess
          Case "#PB_Window_Invisible"               : Flag = Flag | #PB_Window_Invisible
          Case "#PB_Window_Maximize"                : Flag = Flag | #PB_Window_Maximize
          Case "#PB_Window_Minimize"                : Flag = Flag | #PB_Window_Minimize
          Case "#PB_Window_MaximizeGadget"          : Flag = Flag | #PB_Window_MaximizeGadget
          Case "#PB_Window_MinimizeGadget"          : Flag = Flag | #PB_Window_MinimizeGadget
          Case "#PB_Window_NoActivate"              : Flag = Flag | #PB_Window_NoActivate
          Case "#PB_Window_NoGadgets"               : Flag = Flag | #PB_Window_NoGadgets
          Case "#PB_Window_SizeGadget"              : Flag = Flag | #PB_Window_SizeGadget
          Case "#PB_Window_SystemMenu"              : Flag = Flag | #PB_Window_SystemMenu
          Case "#PB_Window_TitleBar"                : Flag = Flag | #PB_Window_TitleBar
          Case "#PB_Window_Tool"                    : Flag = Flag | #PB_Window_Tool
          Case "#PB_Window_ScreenCentered"          : Flag = Flag | #PB_Window_ScreenCentered
          Case "#PB_Window_WindowCentered"          : Flag = Flag | #PB_Window_WindowCentered
            ; buttonimage 
          Case "#PB_Button_Image"                   : Flag = Flag | #PB_Button_Image
          Case "#PB_Button_PressedImage"            : Flag = Flag | #PB_Button_PressedImage
            ; button  
          Case "#PB_Button_Default"                 : Flag = Flag | #PB_Button_Default
          Case "#PB_Button_Left"                    : Flag = Flag | #PB_Button_Left
          Case "#PB_Button_MultiLine"               : Flag = Flag | #PB_Button_MultiLine
          Case "#PB_Button_Right"                   : Flag = Flag | #PB_Button_Right
          Case "#PB_Button_Toggle"                  : Flag = Flag | #PB_Button_Toggle
            ; string
          Case "#PB_String_BorderLess"              : Flag = Flag | #PB_String_BorderLess
          Case "#PB_String_LowerCase"               : Flag = Flag | #PB_String_LowerCase
          Case "#PB_String_MaximumLength"           : Flag = Flag | #PB_String_MaximumLength
          Case "#PB_String_Numeric"                 : Flag = Flag | #PB_String_Numeric
          Case "#PB_String_Password"                : Flag = Flag | #PB_String_Password
          Case "#PB_String_ReadOnly"                : Flag = Flag | #PB_String_ReadOnly
          Case "#PB_String_UpperCase"               : Flag = Flag | #PB_String_UpperCase
            ; text
          Case "#PB_Text_Border"                    : Flag = Flag | #PB_Text_Border
          Case "#PB_Text_Center"                    : Flag = Flag | #PB_Text_Center
          Case "#PB_Text_Right"                     : Flag = Flag | #PB_Text_Right
            ; option
            ; checkbox
          Case "#PB_CheckBox_Center"                : Flag = Flag | #PB_CheckBox_Center
          Case "#PB_CheckBox_Right"                 : Flag = Flag | #PB_CheckBox_Right
          Case "#PB_CheckBox_ThreeState"            : Flag = Flag | #PB_CheckBox_ThreeState
            ; listview
          Case "#PB_ListView_ClickSelect"           : Flag = Flag | #PB_ListView_ClickSelect
          Case "#PB_ListView_MultiSelect"           : Flag = Flag | #PB_ListView_MultiSelect
            ; frame
          Case "#PB_Frame_Double"                   : Flag = Flag | #PB_Frame_Double
          Case "#PB_Frame_Flat"                     : Flag = Flag | #PB_Frame_Flat
          Case "#PB_Frame_Single"                   : Flag = Flag | #PB_Frame_Single
            ; combobox
          Case "#PB_ComboBox_Editable"              : Flag = Flag | #PB_ComboBox_Editable
          Case "#PB_ComboBox_Image"                 : Flag = Flag | #PB_ComboBox_Image
          Case "#PB_ComboBox_LowerCase"             : Flag = Flag | #PB_ComboBox_LowerCase
          Case "#PB_ComboBox_UpperCase"             : Flag = Flag | #PB_ComboBox_UpperCase
            ; image 
          Case "#PB_Image_Border"                   : Flag = Flag | #PB_Image_Border
          Case "#PB_Image_Raised"                   : Flag = Flag | #PB_Image_Raised
            ; hyperlink 
          Case "#PB_HyperLink_Underline"            : Flag = Flag | #PB_HyperLink_Underline
            ; container 
          Case "#PB_Container_BorderLess"           : Flag = Flag | #PB_Container_BorderLess
          Case "#PB_Container_Double"               : Flag = Flag | #PB_Container_Double
          Case "#PB_Container_Flat"                 : Flag = Flag | #PB_Container_Flat
          Case "#PB_Container_Raised"               : Flag = Flag | #PB_Container_Raised
          Case "#PB_Container_Single"               : Flag = Flag | #PB_Container_Single
            ; listicon
          Case "#PB_ListIcon_AlwaysShowSelection"   : Flag = Flag | #PB_ListIcon_AlwaysShowSelection
          Case "#PB_ListIcon_CheckBoxes"            : Flag = Flag | #PB_ListIcon_CheckBoxes
          Case "#PB_ListIcon_ColumnWidth"           : Flag = Flag | #PB_ListIcon_ColumnWidth
          Case "#PB_ListIcon_DisplayMode"           : Flag = Flag | #PB_ListIcon_DisplayMode
          Case "#PB_ListIcon_GridLines"             : Flag = Flag | #PB_ListIcon_GridLines
          Case "#PB_ListIcon_FullRowSelect"         : Flag = Flag | #PB_ListIcon_FullRowSelect
          Case "#PB_ListIcon_HeaderDragDrop"        : Flag = Flag | #PB_ListIcon_HeaderDragDrop
          Case "#PB_ListIcon_LargeIcon"             : Flag = Flag | #PB_ListIcon_LargeIcon
          Case "#PB_ListIcon_List"                  : Flag = Flag | #PB_ListIcon_List
          Case "#PB_ListIcon_MultiSelect"           : Flag = Flag | #PB_ListIcon_MultiSelect
          Case "#PB_ListIcon_Report"                : Flag = Flag | #PB_ListIcon_Report
          Case "#PB_ListIcon_SmallIcon"             : Flag = Flag | #PB_ListIcon_SmallIcon
          Case "#PB_ListIcon_ThreeState"            : Flag = Flag | #PB_ListIcon_ThreeState
            ; ipaddress
            ; progressbar 
          Case "#PB_ProgressBar_Smooth"             : Flag = Flag | #PB_ProgressBar_Smooth
          Case "#PB_ProgressBar_Vertical"           : Flag = Flag | #PB_ProgressBar_Vertical
            ; scrollbar 
          Case "#PB_ScrollBar_Vertical"             : Flag = Flag | #PB_ScrollBar_Vertical
            ; scrollarea 
          Case "#PB_ScrollArea_BorderLess"          : Flag = Flag | #PB_ScrollArea_BorderLess
          Case "#PB_ScrollArea_Center"              : Flag = Flag | #PB_ScrollArea_Center
          Case "#PB_ScrollArea_Flat"                : Flag = Flag | #PB_ScrollArea_Flat
          Case "#PB_ScrollArea_Raised"              : Flag = Flag | #PB_ScrollArea_Raised
          Case "#PB_ScrollArea_Single"              : Flag = Flag | #PB_ScrollArea_Single
            ; trackbar
          Case "#PB_TrackBar_Ticks"                 : Flag = Flag | #PB_TrackBar_Ticks
          Case "#PB_TrackBar_Vertical"              : Flag = Flag | #PB_TrackBar_Vertical
            ; web
            ; calendar
          Case "#PB_Calendar_Borderless"            : Flag = Flag | #PB_Calendar_Borderless
            
            ; date
          Case "#PB_Date_CheckBox"                  : Flag = Flag | #PB_Date_CheckBox
          Case "#PB_Date_UpDown"                    : Flag = Flag | #PB_Date_UpDown
            
            ; editor
          Case "#PB_Editor_ReadOnly"                : Flag = Flag | #PB_Editor_ReadOnly
          Case "#PB_Editor_WordWrap"                : Flag = Flag | #PB_Editor_WordWrap
            
            ; explorerlist
          Case "#PB_Explorer_BorderLess"            : Flag = Flag | #PB_Explorer_BorderLess          ; Создать гаджет без границ.
          Case "#PB_Explorer_AlwaysShowSelection"   : Flag = Flag | #PB_Explorer_AlwaysShowSelection ; Выделение отображается даже если гаджет не активирован.
          Case "#PB_Explorer_MultiSelect"           : Flag = Flag | #PB_Explorer_MultiSelect         ; Разрешить множественное выделение элементов в гаджете.
          Case "#PB_Explorer_GridLines"             : Flag = Flag | #PB_Explorer_GridLines           ; Отображать разделительные линии между строками и колонками.
          Case "#PB_Explorer_HeaderDragDrop"        : Flag = Flag | #PB_Explorer_HeaderDragDrop      ; В режиме таблицы заголовки можно перетаскивать (Drag'n'Drop).
          Case "#PB_Explorer_FullRowSelect"         : Flag = Flag | #PB_Explorer_FullRowSelect       ; Выделение охватывает всю строку, а не первую колонку.
          Case "#PB_Explorer_NoFiles"               : Flag = Flag | #PB_Explorer_NoFiles             ; Не показывать файлы.
          Case "#PB_Explorer_NoFolders"             : Flag = Flag | #PB_Explorer_NoFolders           ; Не показывать каталоги.
          Case "#PB_Explorer_NoParentFolder"        : Flag = Flag | #PB_Explorer_NoParentFolder      ; Не показывать ссылку на родительский каталог [..].
          Case "#PB_Explorer_NoDirectoryChange"     : Flag = Flag | #PB_Explorer_NoDirectoryChange   ; Пользователь не может сменить директорию.
          Case "#PB_Explorer_NoDriveRequester"      : Flag = Flag | #PB_Explorer_NoDriveRequester    ; Не показывать запрос 'пожалуйста, вставьте диск X:'.
          Case "#PB_Explorer_NoSort"                : Flag = Flag | #PB_Explorer_NoSort              ; Пользователь не может сортировать содержимое по клику на заголовке колонки.
          Case "#PB_Explorer_AutoSort"              : Flag = Flag | #PB_Explorer_AutoSort            ; Содержимое автоматически упорядочивается по имени.
          Case "#PB_Explorer_HiddenFiles"           : Flag = Flag | #PB_Explorer_HiddenFiles         ; Будет отображать скрытые файлы (поддерживается только в Linux и OS X).
          Case "#PB_Explorer_NoMyDocuments"         : Flag = Flag | #PB_Explorer_NoMyDocuments       ; Не показывать каталог 'Мои документы' в виде отдельного элемента.
            
            ; explorercombo
          Case "#PB_Explorer_DrivesOnly"            : Flag = Flag | #PB_Explorer_DrivesOnly          ; Гаджет будет отображать только диски, которые вы можете выбрать.
          Case "#PB_Explorer_Editable"              : Flag = Flag | #PB_Explorer_Editable            ; Гаджет будет доступен для редактирования с функцией автозаполнения.  			      С этим флагом он действует точно так же, как тот что в Windows Explorer.
            
            ; explorertree
          Case "#PB_Explorer_NoLines"               : Flag = Flag | #PB_Explorer_NoLines             ; Скрыть линии, соединяющие узлы дерева.
          Case "#PB_Explorer_NoButtons"             : Flag = Flag | #PB_Explorer_NoButtons           ; Скрыть кнопки разворачивания узлов в виде символов '+'.
            
            ; spin
          Case "#PB_Explorer_Type"                  : Flag = Flag | #PB_Spin_Numeric
          Case "#PB_Explorer_Type"                  : Flag = Flag | #PB_Spin_ReadOnly
            ; tree
          Case "#PB_Tree_AlwaysShowSelection"       : Flag = Flag | #PB_Tree_AlwaysShowSelection
          Case "#PB_Tree_CheckBoxes"                : Flag = Flag | #PB_Tree_CheckBoxes
          Case "#PB_Tree_NoButtons"                 : Flag = Flag | #PB_Tree_NoButtons
          Case "#PB_Tree_NoLines"                   : Flag = Flag | #PB_Tree_NoLines
          Case "#PB_Tree_ThreeState"                : Flag = Flag | #PB_Tree_ThreeState
            ; panel
            ; splitter
          Case "#PB_Splitter_Separator"             : Flag = Flag | #PB_Splitter_Separator
          Case "#PB_Splitter_Vertical"              : Flag = Flag | #PB_Splitter_Vertical
          Case "#PB_Splitter_FirstFixed"            : Flag = Flag | #PB_Splitter_FirstFixed
          Case "#PB_Splitter_SecondFixed"           : Flag = Flag | #PB_Splitter_SecondFixed
            ; mdi
          Case "#PB_MDI_AutoSize"                   : Flag = Flag | #PB_MDI_AutoSize
          Case "#PB_MDI_BorderLess"                 : Flag = Flag | #PB_MDI_BorderLess
          Case "#PB_MDI_NoScrollBars"               : Flag = Flag | #PB_MDI_NoScrollBars
            ; scintilla
            ; shortcut
            ; canvas
          Case "#PB_Canvas_Border"                  : Flag = Flag | #PB_Canvas_Border
          Case "#PB_Canvas_ClipMouse"               : Flag = Flag | #PB_Canvas_ClipMouse
          Case "#PB_Canvas_Container"               : Flag = Flag | #PB_Canvas_Container
          Case "#PB_Canvas_DrawFocus"               : Flag = Flag | #PB_Canvas_DrawFocus
          Case "#PB_Canvas_Keyboard"                : Flag = Flag | #PB_Canvas_Keyboard
        EndSelect
        
      Next
    EndIf
    
    ProcedureReturn Flag
  EndProcedure
  
  Procedure SetPBFlag(Object)
    Protected i, Flag.q, Gadget = EventGadget() ; Properties()\Tree
    
    If IsGadget(Gadget)
      i=GetGadgetState(Gadget)
      
      Flag = GetPBFlag(GetGadgetItemText(Gadget, i))
      
      If IsGadget(Object)
        Select Bool(GetGadgetItemState(Gadget, i) & #PB_Tree_Checked)
          Case 1 : SetGadgetFlag(Object, Flag)
          Case 0 : RemoveGadgetFlag(Object, Flag)
        EndSelect
      ElseIf IsWindow(Object)
        Select Bool(GetGadgetItemState(Gadget, i) & #PB_Tree_Checked)
          Case 1 : SetWindowFlag(Object, Flag)
          Case 0 : RemoveWindowFlag(Object, Flag)
        EndSelect
      EndIf
      
      ; Это что бы не нарушалось закрытие окна
      ; трии гаджета после потери фокуса
      SetActiveWindow(EventWindow())
    EndIf
  EndProcedure
  
  ;-    
  Procedure SetLayoutLang( kbLayout$ );
    #ENGLISH = "00000409"             ;
    #RUSSIAN = "00000419"             ;
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        
        ;     ;Переключаем на английскую раскладку
        ;     If GetKeyboardLayout_(0) = 68748313 ;- US <-> Rus раскладка
        ;       ActivateKeyboardLayout_(#HKL_NEXT, 0)
        ;     EndIf
        ;     
        ;     ; Переключаем на русскую раскладку 
        ;     If GetKeyboardLayout_(0) = 67699721 ; US раскладка
        ;       ActivateKeyboardLayout_(#HKL_NEXT, 0)
        ;     EndIf
        
        Protected Layout = LoadKeyboardLayout_( kbLayout$, 0 ) ; Получить ссылку на раскладку
        SendMessage_( GetForegroundWindow_(), #WM_INPUTLANGCHANGEREQUEST, 1, Layout ) ; посылаем сообщение о смене раскладки
    CompilerEndSelect
  EndProcedure
  
  Procedure StringProc()
    
    Select EventType()
      Case #PB_EventType_Focus 
        AddKeyboardShortcut( EventWindow(), #PB_Shortcut_Return, 1 )
        
      Case #PB_EventType_LostFocus 
        RemoveKeyboardShortcut( EventWindow(), #PB_Shortcut_Return )
        
    EndSelect
    
  EndProcedure
  
  Procedure.S FontName( FontID )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows 
        Protected sysFont.LOGFONT
        GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
        ProcedureReturn PeekS(@sysFont\lfFaceName[0])
        
      CompilerCase #PB_OS_Linux
;         Protected gVal.GValue
;         Protected.s StdFnt
;         g_value_init_( @gval, #G_TYPE_STRING )
;         g_object_get_Properties( gtk_settings_get_default_(), "gtk-font-name", @gval )
;         StdFnt = PeekS( g_value_get_string_( @gval ), -1, #PB_UTF8 )
;         g_value_unset_( @gval )
;         ProcedureReturn StdFnt 
        
    CompilerEndSelect
  EndProcedure
  
  Procedure FontSize( FontID )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows 
        Protected sysFont.LOGFONT
        GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
        ProcedureReturn MulDiv_(-sysFont\lfHeight, 72, GetDeviceCaps_(GetDC_(#NUL), #LOGPIXELSY))
        
      CompilerCase #PB_OS_Linux
;         Protected   gVal.GValue
;         Protected.s StdFnt
;         g_value_init_(@gval, #G_TYPE_STRING)
;         g_object_get_Properties( gtk_settings_get_default_(), "gtk-font-name", @gval)
;         StdFnt= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
;         g_value_unset_(@gval)
;         ProcedureReturn Val(StringField((StdFnt), 2, " "))
        
    CompilerEndSelect
  EndProcedure
  
  Procedure$ GetCheckedText(Gadget)
    Protected i, Result$
    For i=0 To CountGadgetItems(Gadget)-1
      If GetGadgetItemState(Gadget, i) & #PB_Tree_Checked  
        Result$ + GetGadgetItemText(Gadget, i)+"|"
      EndIf
    Next
    ProcedureReturn Trim(Result$, "|")
  EndProcedure
  
  Procedure SetCheckedText(Gadget, Text$)
    Protected i,ii
    For i=0 To CountString(Text$, "|")
      For ii=0 To CountGadgetItems(Gadget)-1
        If GetGadgetItemText(Gadget, ii) = Trim( StringField( Text$, (i + (1)), "|"))
          SetGadgetItemState(Gadget, ii, #PB_Tree_Checked) 
        EndIf
      Next
    Next
  EndProcedure
  
  Procedure Update( Object )
    Protected Color
    
    With Properties()
      If IsGadget( Object ) 
        Select Trim(\Info.S)
          Case "ID:"   
            If IsGadget(\CheckBox)
              SetGadgetState(\CheckBox, Bool(Asc(\Class$) = '#'))
            EndIf
            
          Case "Text:"   : SetGadgetText(\String, GetGadgetText(Object))
          Case "Hide:"   : SetGadgetState(\ComboBox, IsHideGadget(Object))
          Case "Disable:": SetGadgetState(\ComboBox, IsDisableGadget(Object))
          Case "Font:"   : SetGadgetText(\String, "("+ Str(FontSize( GetGadgetFont(Object) )) +") "+ FontName( GetGadgetFont(Object) ) )   
          Case "Color:"  : Color = GetGadgetColor( Object, #PB_Gadget_BackColor )
            ;             If Color =- 1
            ;               DisableGadget( \Button, 1) 
            ;               DisableGadget( \String, 1) 
            ;               SetGadgetText(\String, " False")
            ;             Else
            DisableGadget( \Button, 0) 
            DisableGadget( \String, 0) 
            SetGadgetText(\String, " "+Str(Red(Color))+";"+Str(Blue(Color))+";"+Str(Green(Color)))
            ;             EndIf
            
          Case "X:"      : SetGadgetState(\Spin, GadgetX(Object))
          Case "Y:"      : SetGadgetState(\Spin, GadgetY(Object))
          Case "Width:"  : SetGadgetState(\Spin, GadgetWidth(Object))
          Case "Height:" : SetGadgetState(\Spin, GadgetHeight(Object))
            
        EndSelect
        
      ElseIf IsWindow( Object )  
        Select Trim(\Info.S)
          Case "Text:"   : SetGadgetText(\String, GetWindowTitle(Object))
            
          Case "Hide:"   : SetGadgetState(\ComboBox, IsHideWindow(Object))
          Case "Disable:": SetGadgetState(\ComboBox, IsDisableWindow(Object))
          Case "Font:"   : SetGadgetText(\String, "("+ Str(FontSize( GetGadgetFont(#PB_Default) )) +") "+  FontName( GetGadgetFont(#PB_Default)) )   
          Case "Color:"  : Color = GetWindowColor(Object)
            
            ;               If Color =- 1
            ;                 DisableGadget( \Button, 1) 
            ;                 DisableGadget( \String, 1) 
            ;                 SetGadgetText(\String, " False")
            ;               Else
            DisableGadget( \Button, 0) 
            DisableGadget( \String, 0) 
            SetGadgetText(\String, " "+Str(Red(Color))+";"+Str(Blue(Color))+";"+Str(Green(Color)))
            ;               EndIf
            
          Case "X:"      : SetGadgetState(\Spin, WindowX(Object))
          Case "Y:"      : SetGadgetState(\Spin, WindowY(Object))
          Case "Width:"  : SetGadgetState(\Spin, WindowWidth(Object))
          Case "Height:" : SetGadgetState(\Spin, WindowHeight(Object))
        EndSelect
      EndIf
      
      Select Trim(\Info.S)
        Case "ID:"     : SetGadgetText(\String, \Class$)
        Case "Flag:"   : SetGadgetText(\String, \Flag$)
          Protected IC, Len, height
          If IsGadget(\Tree)
            If IsGadget(Object)
              \Text = GetPBFlags(GadgetType(Object))
            ElseIf IsWindow(Object)
              \Text = GetPBFlags()
            EndIf
            
            ClearGadgetItems(\Tree)
            
            For IC=0 To CountString(\Text.S,"|")
              If Trim(StringField(\Text.S,IC+1,"|"))
                If Len<Len(Trim(StringField(\Text.S,IC+1,"|")))
                  Len=Len(Trim(StringField(\Text.S,IC+1,"|")))
                EndIf
                AddGadgetItem(\Tree,-1,Trim(StringField(\Text.S,IC+1,"|")))
              EndIf
            Next
            
            height = (IC*17) : If height>100 : height = 100 : EndIf
            
            If height
              If IsWindow(\TreeWindow) : ResizeWindow(\TreeWindow, #PB_Ignore, #PB_Ignore, len*9, height) : EndIf
              If IsGadget(\Tree) : ResizeGadget(\Tree, #PB_Ignore, #PB_Ignore, len*9, height) : EndIf
            EndIf
          EndIf
      EndSelect
    EndWith
    
  EndProcedure
  
  Procedure Changes( Object )
    
    With Properties()
      If IsGadget( Object ) 
        Select Trim(\Info.S)
            ;Case "Type:"   : SetGadgetText(\String, Class(GadgetType(Object)) + "Gadget()")
          Case "Text:"   
            Select GadgetType( Object )
              Case #PB_GadgetType_ComboBox
                AddGadgetItem(Object, - 1, GetGadgetText(\String))
                SetGadgetState(Object, CountGadgetItems(Object) - 1)
                ;RemoveGadgetItem(\CheckGadget,CountGadgetItems(\CheckGadget) - 1)
                
              Case #PB_GadgetType_Shortcut
                SetGadgetState(Object, GetGadgetState( \String )) ;Asc(UCase(GetGadgetText(\String))))
              Case #PB_GadgetType_IPAddress
                SetGadgetState(Object, GetGadgetState( \String )) 
                
              Default
                SetGadgetText(Object, GetGadgetText(\String))
            EndSelect
            
          Case "Disable:": DisableGadget( Object, GetGadgetState( \ComboBox ))
          Case "Hide:"   : HideGadget( Object, GetGadgetState( \ComboBox ))
          Case "Color:"  : SetGadgetColor( Object, #PB_Gadget_BackColor, ColorRequester() )
          Case "Font:"   : FontRequester( "Arial", 8, #PB_FontRequester_Effects) 
            \Str.S = SelectedFontName()
            SetGadgetFont( Object, FontID( LoadFont( #PB_Any, \Str.S, SelectedFontSize(), SelectedFontStyle() ) ) )
            
            
          Case "X:"      : ResizeGadget( Object, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Case "Y:"      : ResizeGadget( Object, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore )
          Case "Width:"  : ResizeGadget( Object, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore )
          Case "Height:" : ResizeGadget( Object, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin) )
        EndSelect
        
      ElseIf  IsWindow( Object ) 
        Select Trim(\Info.S)
            ;Case "Type:"   : SetGadgetText(\String, "Open"+Class(-1)+"()")
          Case "Text:"   : SetWindowTitle( Object, GetGadgetText(\String))
            
          Case "Disable:": DisableWindow( Object, GetGadgetState( \ComboBox ))
          Case "Hide:"   : HideWindow( Object, GetGadgetState( \ComboBox ))
          Case "Color:"  : SetWindowColor( Object, ColorRequester() ) : \Int = GetWindowColor( Object ) ;: SetWindowPoint( Object )
          Case "Font:"   : FontRequester( FontName( GetGadgetFont(#PB_Default) ), 8, #PB_FontRequester_Effects)
            \Str.S = SelectedFontName()
            SetGadgetFont( #PB_Default, FontID( LoadFont( #PB_Any, \Str.S, SelectedFontSize(), SelectedFontStyle() ) ) )
            
            
          Case "X:"      : ResizeWindow( Object, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Case "Y:"      : ResizeWindow( Object, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore )
          Case "Width:"  : ResizeWindow( Object, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore )
          Case "Height:" : ResizeWindow( Object, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin) )
        EndSelect
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure Init( Object, Class$="", Flag$="" )
    Static CheckObject =- 1
    
    With Properties()
      ;If CheckObject <> Object
        ForEach Properties()
          \Object = Object
          \Class$ = Class$
          
          If Flag$=""
            ; \Flag$ = 
          Else
            \Flag$ = Flag$
          EndIf
          
          Update( Object )
        Next
        CheckObject = Object
      ;EndIf
    EndWith
    
  EndProcedure
  
  Procedure Change(gadget, Object, Class$="", Flag$="")
    ProcedureReturn  Init( Object, Class$, Flag$ )
  EndProcedure
  
  Procedure CallBack()
    Static Window=-1, Gadget=-1, Click
    
    Select Event()
      Case #PB_Event_DeactivateWindow 
        If IsGadget(Gadget)
          Protected MouseX = DesktopMouseX()
          Protected MouseY = DesktopMouseY()
          Protected GadgetX = GadgetX(Gadget ,#PB_Gadget_ScreenCoordinate)
          Protected GadgetY = GadgetY(Gadget ,#PB_Gadget_ScreenCoordinate)
          Protected GadgetWidth = GadgetX + GadgetWidth(Gadget)
          Protected GadgetHeight = GadgetY + GadgetHeight(Gadget)
          
          If Bool(WindowMouseX(EventWindow())=-1 And WindowMouseY(EventWindow())=-1) And 
             Not Bool(MouseX >= GadgetX And MouseY >= GadgetY And MouseX =< GadgetWidth And MouseY =< GadgetHeight)
            PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_LeftClick)
          EndIf
        EndIf
        
      Case #PB_Event_Gadget
        ForEach Properties()
          With Properties()
            Select EventGadget()
              Case \String
                ;   #PB_EventType_Change    : The Text has been modified by the user.
                ;   #PB_EventType_Focus     : The StringGadget got the focus.
                ;   #PB_EventType_LostFocus : The StringGadget lost the focus.
                Select EventType()
                  Case #PB_EventType_LeftClick
                    Changes( \Object )
                    Update( \Object )
                    
                  Case #PB_EventType_Change
                    ;If GetGadgetText(\String) = "" : SetGadgetText(\String, \Str) : EndIf
                    
                    ; Вводить только английские буквы
                    If Trim(\Info.S)="ID:" 
                      Static LastText.s
                      Protected ChangeText=#True
                      If Len(LastText)<Len(GetGadgetText(\String))
                        Select Asc(ReplaceString(GetGadgetText(\String), LastText, "", #PB_String_CaseSensitive ,1,1))
                          Case 'A' To 'Z', 'a' To 'z', '0' To '9', '_'
                            SetGadgetColor(\String, #PB_Gadget_BackColor, $FFFFFF)
                          Default 
                            SetGadgetColor(\String, #PB_Gadget_BackColor, $0000FF)
                            If Len(GetGadgetText(\String)) = 1
                              SetGadgetText(\String, \Str )
                            Else
                              ChangeText=#False
                            EndIf
                        EndSelect
                      Else
                        Select Asc(GetGadgetText(\String))
                          Case 'A' To 'Z', 'a' To 'z', '0' To '9', '_'
                            Select Asc(ReverseString(GetGadgetText(\String)))
                              Case 'A' To 'Z', 'a' To 'z', '0' To '9', '_'
                                SetGadgetColor(\String, #PB_Gadget_BackColor, $FFFFFF)
                            EndSelect
                          Default 
                            SetGadgetColor(\String, #PB_Gadget_BackColor, $0000FF)
                            SetGadgetText(\String, \Str )
                        EndSelect
                      EndIf
                      
                      If ChangeText 
                        LastText=GetGadgetText(\String) 
                      EndIf
                    EndIf
                    
                    Changes( \Object )
                    
                    ;                Case  #PB_EventType_LeftClick ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \String )
                  Case #PB_EventType_Focus ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Focus, \String )
                    \Str = GetGadgetText(\String) ; Запоминаем на тот случай если данные пусти чтобы возвратить исходние
                    
                  Case #PB_EventType_LostFocus ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_LostFocus, \String )
                    If GetGadgetText(\String) = "" : SetGadgetText(\String, \Str ) : EndIf ; Вот тут и понадобятся данные
                    If Trim(\Info.S)="ID:" 
                      SetGadgetColor(\String, #PB_Gadget_BackColor, $FFFFFF)
                    EndIf
                  
                EndSelect
                
              Case \ComboBox
                ;   #PB_EventType_Change    : The current selection of the Text in the edit field changed.
                ;   #PB_EventType_Focus     : The edit field received the keyboard focus (editable ComboBox only).
                ;   #PB_EventType_LostFocus : The edit field lost the keyboard focus (editable ComboBox only).
                Select EventType()
                  Case #PB_EventType_LeftClick
                    Changes( \Object )
                    Update( \Object )
                    
                  Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \ComboBox )
                    Changes( \Object )
                    
                    ;               Case #PB_EventType_Focus : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Focus, \ComboBox )
                    ;               Case #PB_EventType_LostFocus : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_LostFocus, \ComboBox )
                    
                EndSelect
                
              Case \Spin
                ;   #PB_EventType_Change : The Text in the edit area has been modified by the user.
                ;   #PB_EventType_Up     : The 'Up' button was pressed.
                ;   #PB_EventType_Down   : The 'Down' button was pressed.
                Select EventType()
                  Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \Spin )
                    Changes( \Object )
                    
                  Case #PB_EventType_Up ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Up, \Spin )
                  Case #PB_EventType_Down ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Down, \Spin )
                    
                EndSelect
                
              Case \Tree
                ;   #PB_EventType_LeftClick : Клик левой кнопкой мыши на элементе, или галочка на чек-боксе установлена/снята. 
                ;   #PB_EventType_LeftDoubleClick : Двойной клик левой кнопкой мыши на элементе.
                ;   #PB_EventType_RightClick : Клик правой кнопкой мыши на элементе
                ;   #PB_EventType_RightDoubleClick : Двойной Клик левой кнопкой мыши на элементе.
                ;   #PB_EventType_Change: Текущий элемент изменен.
                ;   #PB_EventType_DragStart: Пользователь попытался запустить операцию Drag & Drop.
                Select EventType()
                  Case #PB_EventType_Focus 
                    SetCheckedText(\Tree, \Flag$)
                    
                  Case #PB_EventType_LostFocus 
                    \Flag$ = GetCheckedText(\Tree)
                    SetGadgetText(\String, \Flag$)
                    
                  Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \Tree )
                    Changes( \Object )
                    SetPBFlag(\Object)
                    
                EndSelect
                
              Case \Button
                Select EventType()
                  Case #PB_EventType_LeftClick 
                    If GadgetType(GetGadgetData(\Button)) = #PB_GadgetType_Tree
                      If CountGadgetItems(\Tree) : Click!1
                        If Click
                          Gadget = EventGadget()
                          Window = EventWindow()
                          HideWindow(\TreeWindow, #False)
                          PostEvent(#PB_Event_Gadget, Window, \Tree, #PB_EventType_Focus, Gadget )
                          ResizeWindow(\TreeWindow, (GadgetX(\Button, #PB_Gadget_ScreenCoordinate)+GadgetWidth(\Button))-GadgetWidth(\Tree)-1, GadgetY(\Button, #PB_Gadget_ScreenCoordinate)+GadgetHeight(\Button), #PB_Ignore, #PB_Ignore)
                        Else
                          PostEvent(#PB_Event_Gadget, Window, \Tree, #PB_EventType_LostFocus, Gadget )
                          HideWindow(\TreeWindow, #True)
                          Window=-1 
                          Gadget=-1
                        EndIf
                      EndIf
                    Else
                      PostEvent(#PB_Event_Gadget, EventWindow(), GetGadgetData(\Button), #PB_EventType_LeftClick, \Button )
                    EndIf
                EndSelect
                
              Case \CheckBox
                Select EventType()
                  Case #PB_EventType_LeftClick 
                    If GetGadgetState(\CheckBox) 
                      SetGadgetText(GetGadgetData(\CheckBox), "#"+GetGadgetText(GetGadgetData(\CheckBox)))
                    Else
                      SetGadgetText(GetGadgetData(\CheckBox), Trim(GetGadgetText(GetGadgetData(\CheckBox)), "#"))
                    EndIf
                    SetActiveGadget(GetGadgetData(\CheckBox))
                    PostEvent(#PB_Event_Gadget, EventWindow(), GetGadgetData(\CheckBox), #PB_EventType_Change, \CheckBox )
                    SetActiveGadget(\CheckBox)
                  EndSelect
            EndSelect
          EndWith
        Next
    EndSelect
    
  EndProcedure
  
  Procedure Size( Width, Height )
    If ListSize(Properties())
      With Properties()
        If IsGadget(\Gadget)
          ResizeGadget( \Gadget, #PB_Ignore,#PB_Ignore, Width, Height )
          
          If GetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerHeight)  > GadgetHeight(\Gadget) - 2
            SetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerWidth, GadgetWidth(\Gadget) - 20)
          Else
            SetGadgetAttribute(\Gadget, #PB_ScrollArea_InnerWidth, GadgetWidth(\Gadget) - 4)
          EndIf
          
          ForEach Properties()
            Protected LinePos = #PB_Ignore
            If \LinePos <> GadgetWidth(LineGadget)
              \LinePos = GadgetWidth(LineGadget)
              LinePos = \LinePos
            EndIf
            Protected W = GetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerWidth)-\LinePos
            
            If IsGadget(\Button)
              W-(GadgetWidth(\Button) - 1)
              ResizeGadget(\Button, (\LinePos+W),#PB_Ignore,#PB_Ignore,#PB_Ignore)
            EndIf
            
            If IsGadget(\Spin)
              ResizeGadget(\Spin, LinePos,#PB_Ignore,W,#PB_Ignore)
            EndIf
            
            If IsGadget(\ComboBox)
              ResizeGadget(\ComboBox, LinePos,#PB_Ignore,W,#PB_Ignore)
            EndIf
            
            If IsGadget(\String)
              ResizeGadget(\String , LinePos,#PB_Ignore,W,#PB_Ignore)
            EndIf
          Next
          
        EndIf
      EndWith
    EndIf
  EndProcedure 
  
  Procedure Repaint()
    Protected X,Width 
    
    With Properties()
      Protected Y = ListIndex(Properties()) * \ItemHeight
      
      If \Font = #False
        \Font = GetGadgetFont(#PB_Default)
        \Font = LoadFont(#PB_Any, PeekS(@\Font),  8);, #PB_Font_Bold )
      EndIf
      
      X = 16
      Width = GadgetWidth(LineGadget)
      
      
      If StartDrawing(CanvasOutput(LineGadget))
        ;ClipOutput(0,Y,X+1,OutputHeight())
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,Y,X+1,OutputHeight(), $E7E7E7)
        
        If ListIndex(Properties()) = \Seperator
          ClipOutput(2,Y,Width,\ItemHeight)
          DrawingMode(#PB_2DDrawing_Default)
          Box(X,Y,Width,\ItemHeight, $F0F0F0)
          ; Line(X,Y,1,\ItemHeight,$C0C0C0)
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(2,Y+(\ItemHeight-12)/2,12,12, 0)
          Line(5,Y+(\ItemHeight-12)/2+6,6,1,0)
          
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawingFont(FontID(\Font) )
          DrawText(X+3,Y+(\ItemHeight-TextHeight(\Info.S))/2+1,\Info.S,0)
        Else
          ClipOutput(X,Y+1,Width-1,\ItemHeight-1)
          DrawingMode(#PB_2DDrawing_Default)
          Box(X+1,Y+2,Width-17-2,\ItemHeight-2, $F5F5F5)
          
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawingFont(FontID(\Font))
          DrawText(Width-5-TextWidth(\Info.S),Y+(\ItemHeight-TextHeight(\Info.S))/2+1,\Info.S,0)
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(X,Y+1,Width-17,\ItemHeight-1, $A9A9A9)
        EndIf
        
        StopDrawing()
      EndIf
    EndWith    
  EndProcedure
  
  Procedure EventSplitter()
    Static SplitterGadget =-1
    Select EventType()
      Case #PB_EventType_LeftButtonDown 
        If GetGadgetAttribute(EventGadget(),#PB_Canvas_MouseX) >= GadgetWidth(EventGadget())-3
          SplitterGadget = EventGadget() 
        EndIf
        
        ;         CompilerSelect #PB_Compiler_OS
        ;           CompilerCase #PB_OS_Windows
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE) | #WS_CLIPCHILDREN)
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE) | #WS_EX_COMPOSITED)
        ;             
        ;         CompilerEndSelect
        
      Case #PB_EventType_LeftButtonUp  
        If IsGadget(SplitterGadget) 
          SplitterGadget =-1
        EndIf
        ;         CompilerSelect #PB_Compiler_OS
        ;           CompilerCase #PB_OS_Windows
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE) &~ #WS_CLIPCHILDREN)
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE) &~ #WS_EX_COMPOSITED)
        ;             
        ;         CompilerEndSelect
        
      Case #PB_EventType_MouseMove
        If IsGadget(SplitterGadget)
          ResizeGadget(SplitterGadget,#PB_Ignore,#PB_Ignore,WindowMouseX(EventWindow())-GadgetX(Properties()\Gadget, #PB_Gadget_WindowCoordinate),#PB_Ignore)
          Size( #PB_Ignore,#PB_Ignore )
          ForEach Properties()
            Repaint()
          Next
          
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              RedrawWindow_(WindowID(EventWindow()), 0, 0, #RDW_ALLCHILDREN|#RDW_UPDATENOW)
          CompilerEndSelect
        EndIf
        
        ;
        If GetGadgetAttribute(EventGadget(),#PB_Canvas_MouseX) >= GadgetWidth(EventGadget())-3
          SetGadgetAttribute(EventGadget(),#PB_Canvas_Cursor,#PB_Cursor_LeftRight)
        Else
          SetGadgetAttribute(EventGadget(),#PB_Canvas_Cursor,#PB_Cursor_Default)
        EndIf
        
    EndSelect
    
  EndProcedure 
  
  Procedure Gadget( Gadget, Width, Height, LinePos = 75 )
    Protected ItemHeight
    Shared LineGadget
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        ItemHeight = 24
      CompilerCase #PB_OS_Linux
        ItemHeight = 18
    CompilerEndSelect
    
    Gadget = ScrollAreaGadget( #PB_Any,0,0,Width,Height, Width,Height,ItemHeight,#PB_ScrollArea_Single)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected ParentID = GadgetID(Gadget)
        If FindWindowEx_( FindWindowEx_( ParentID, 0,0,0 ), 0,0,0 ) ; ScrollArea
          ParentID = FindWindowEx_( ParentID, 0,0,0 )
        EndIf
        SetWindowLongPtr_(ParentID, #GWL_STYLE, GetWindowLongPtr_(ParentID, #GWL_STYLE) | #WS_CLIPCHILDREN)
        SetWindowLongPtr_(ParentID, #GWL_EXSTYLE, GetWindowLongPtr_(ParentID, #GWL_EXSTYLE) | #WS_EX_COMPOSITED)
    CompilerEndSelect
    
    LineGadget = CanvasGadget( #PB_Any, 0,0,LinePos,0) : Clip(LineGadget)
    BindGadgetEvent(LineGadget,@EventSplitter())
    
    CloseGadgetList()
    ProcedureReturn Gadget
  EndProcedure 
  
  Procedure AddItem( Gadget, Text.S, GadgetType)
    Protected Y,W,Width, Result =- 1, Bw = 19
    ;Protected *This.PropertiesStruct = GetGadgetData(Gadget)

    If OpenGadgetList( Gadget )
      AddElement(Properties())
      With Properties()
        
        \Object =- 1
        
        \Tree =- 1
        \Spin =- 1
        \String =- 1
        \Button =- 1
        \ComboBox =- 1
        \Seperator =- 1
        \TreeWindow =- 1
        
        \Gadget = Gadget
        \GadgetType = GadgetType
        
        \LinePos = GadgetWidth(LineGadget)
        \Font = LoadFont(#PB_Any,"MS Shell Dlg",8+Bool(#PB_Compiler_OS = #PB_OS_MacOS)*4 ) 
        \ItemHeight = GetGadgetAttribute(\Gadget,#PB_ScrollArea_ScrollStep)
        \ItemHeight = 20
          
        SetGadgetAttribute(\Gadget, #PB_ScrollArea_InnerHeight, ListSize(Properties()) * \ItemHeight)
        ResizeGadget(LineGadget,#PB_Ignore,#PB_Ignore,#PB_Ignore, GetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerHeight))
        
        Y = ListIndex(Properties()) * \ItemHeight
        Width = GetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerWidth) - \LinePos 
        
        ;{ - Здесь происходит разделение текста
        Protected IT.I,String.S,Character.C = ':'
        Protected CountString.I = CountString( Text.S, Chr(Character))
        If CountString
          For IT = 0 To CountString
            String.S = Trim( StringField( Text.S, (IT + (1)), Chr(Character)))
            If String.S
              If IT
                \Text.S = String.S
              Else
                \Info.S = String.S + ":"
              EndIf
            EndIf
          Next
        Else
          \Info.S = Text.S+":"
        EndIf
        ;}
        
        If ((GadgetType & #PB_GadgetType_Tree) = #PB_GadgetType_Tree)
          Protected UseGadgetList
          CloseGadgetList()
          UseGadgetList = UseGadgetList(0)
          \TreeWindow = OpenWindow(#PB_Any, \LinePos,Y + 1,Width, 100, "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Invisible, UseGadgetList)
          \Tree = TreeGadget(#PB_Any, 0,0,0,0, #PB_Tree_NoLines|#PB_Tree_NoButtons|#PB_Tree_CheckBoxes) : Result = \Tree
          If IsFont(\Font) : SetGadgetFont(\Tree, FontID(\Font)) : EndIf
          BindEvent(#PB_Event_DeactivateWindow, @CallBack(), \TreeWindow)
          
;           BindEvent(#PB_Event_Gadget, @CallBack(), GetActiveWindow(), \Tree)
          BindGadgetEvent(\Tree, @CallBack(), #PB_EventType_Change)
          
          StickyWindow(\TreeWindow, #True)
          UseGadgetList(UseGadgetList)
          OpenGadgetList( \Gadget )
          Clip(\Tree) 
          
          \String = StringGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,\Text.S) :Clip(\String)
          If IsFont(\Font) : SetGadgetFont(\String, FontID(\Font)) : EndIf
          BindGadgetEvent(\String,@CallBack())
          
        ElseIf ((GadgetType & #PB_GadgetType_Spin) = #PB_GadgetType_Spin)
          \Spin = SpinGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,-32767,32767,#PB_Spin_Numeric) : Result = \Spin
          If IsFont(\Font) : SetGadgetFont(\Spin, FontID(\Font)) : EndIf
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              SetWindowLongPtr_( GetWindow_(GadgetID( \Spin ), #GW_HWNDNEXT), #GWL_STYLE, GetWindowLongPtr_( GetWindow_(GadgetID( \Spin ), #GW_HWNDNEXT), #GWL_STYLE )|#WS_CLIPSIBLINGS )
              SetWindowLongPtr_( GadgetID( \Spin ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( \Spin ), #GWL_STYLE )|#WS_CLIPSIBLINGS|#SS_CENTER )
          CompilerEndSelect
          BindGadgetEvent(\Spin, @CallBack())
          
        
        ElseIf ((GadgetType & #PB_GadgetType_ComboBox) = #PB_GadgetType_ComboBox)
          Protected IC 
          \ComboBox = ComboBoxGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1) :Clip(\ComboBox): Result = \ComboBox
          If IsFont(\Font) : SetGadgetFont(\ComboBox, FontID(\Font)) : EndIf
          
          For IC=0 To CountString(\Text.S,"|")
            If Trim(StringField(\Text.S,IC+1,"|"))
              AddGadgetItem(\ComboBox,-1,Trim(StringField(\Text.S,IC+1,"|")))
            EndIf
          Next
          SetGadgetState(\ComboBox, 0)
          BindGadgetEvent(\ComboBox,@CallBack())
          
        
        ElseIf Bool((GadgetType & #PB_GadgetType_String) = #PB_GadgetType_String)
          \String = StringGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,\Text.S) :Clip(\String): Result = \String
          If IsFont(\Font) : SetGadgetFont(\String, FontID(\Font)) : EndIf
          BindGadgetEvent(\String,@CallBack())
        Else
          \Seperator = ListIndex(Properties())
        EndIf
        
        If Bool((GadgetType & #PB_GadgetType_CheckBox) = #PB_GadgetType_CheckBox)
          \CheckBox = CheckBoxGadget(#PB_Any, 19,Y + 2,25,\ItemHeight - 3,"#") :Clip(\CheckBox)
          If IsFont(\Font) : SetGadgetFont(\CheckBox, FontID(\Font)) : EndIf
          BindGadgetEvent(\CheckBox,@CallBack())
          SetGadgetData(\CheckBox, Result)
        EndIf
        
        If ((GadgetType & #PB_GadgetType_Button) = #PB_GadgetType_Button)
          If ((GadgetType & #PB_GadgetType_Tree) = #PB_GadgetType_Tree)
            \Button = ButtonGadget(#PB_Any, (\LinePos+Width-Bw),Y,Bw + 1,\ItemHeight + 1,">>") :Clip(\Button)
            If IsFont(\Font) : SetGadgetFont(\Button, FontID(\Font)) : EndIf
          Else
            \Button = ButtonGadget(#PB_Any, (\LinePos+Width-Bw),Y,Bw + 1,\ItemHeight + 1,"...") :Clip(\Button)
          EndIf
          
          BindGadgetEvent(\Button, @CallBack())
          SetGadgetData(\Button, Result)
        EndIf
        
        SetGadgetData(\Gadget, Properties())
        
        PushListPosition(Properties())
        Size( GadgetWidth(\Gadget), GadgetHeight(\Gadget))
        Repaint()
        PopListPosition(Properties())
      EndWith
      CloseGadgetList()
    EndIf
    
    ProcedureReturn Result ; ListSize(Properties()) - 1
  EndProcedure 
  
  Procedure$ Help(Gadget)
    Protected Result$, Type$
    
    With Properties()
      ForEach Properties()
        Type$ = \Info
        Select Gadget
          Case \Spin : Break
          Case \String : Break
          Case \ComboBox : Break
        EndSelect
      Next
      
      Select Type$
        Case "X:" : Result$ = "Горизонтальная позиция."
        Case "Y:" : Result$ = "Вертикальная позиция."
        Case "Width:" : Result$ = "Ширина в пикселях."
        Case "Height:" : Result$ = "Высота пикселях."
        Case "Image:" : Result$ = "Рисунок для отображения."
        Case "Font:" : Result$ = "Шрифт для отображения."
        Case "Color:" : Result$ = "Цвет для отображения."
        Case "Flag:" : Result$ = "Флаг для отображения."
      EndSelect
    EndWith
    
    ProcedureReturn Result$
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Global.i Window_0=-1, 
          Window_0_Select=-1, 
        Window_0_Properties=-1
  
  Enumeration Gadget
    #Window_0_Button_1
  EndEnumeration
  
  Declare Window_0_Event()
  Declare Window_0_Size_Event()
  
  Procedure Form_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(0)
    OpenWindow(0,230,230,200,200,"Form_0", Flag)
    TextGadget(1, 10,10,80,20,"Text_0")
    StringGadget(2, 10,35,80,20,"String_0")
    ButtonGadget(3, 10,70,80,60,"Button_1 text multi line", #PB_Button_Toggle)
    CheckBoxGadget(4, 10,135,80,25, "CheckBox")
    ;ContainerGadget(4, 10,135,80,25) : CloseGadgetList() ; , #PB_ComboBox_Editable)
    
    AddGadgetItem(Window_0_Select, -1, "Form_0")
    AddGadgetItem(Window_0_Select, -1, "Text_0")
    AddGadgetItem(Window_0_Select, -1, "String_0")
    AddGadgetItem(Window_0_Select, -1, "Button_1")
    AddGadgetItem(Window_0_Select, -1, "ComboBox_1")
    
    Protected i
    For i=0 To 4
      SetGadgetItemData(Window_0_Select, i,i)
    Next
    
    ;     BindEvent(#PB_Event_Gadget, @Form_0_Event(), Form_0)
  EndIf
  ProcedureReturn 0
EndProcedure


  Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
    Protected h=24
    If Not IsWindow(Window_0)
      Window_0 = OpenWindow(#PB_Any,230,230,200,300,"Window_0", Flag)
      Window_0_Select = ComboBoxGadget(#PB_Any, 0,0, 200,h)
      Window_0_Properties = Properties::Gadget( #PB_Any, 200,300 )
      
      Properties::AddItem( Window_0_Properties, "ID:", #PB_GadgetType_String | #PB_GadgetType_CheckBox )
      Properties::AddItem( Window_0_Properties, "Text:", #PB_GadgetType_String )
      Properties::AddItem( Window_0_Properties, "Disable:False|True", #PB_GadgetType_ComboBox )
      Properties::AddItem( Window_0_Properties, "Hide:False|True", #PB_GadgetType_ComboBox )
      
      Properties::AddItem( Window_0_Properties, "Layouts:", #False )
      Properties::AddItem( Window_0_Properties, "X:", #PB_GadgetType_Spin )
      Properties::AddItem( Window_0_Properties, "Y:", #PB_GadgetType_Spin )
      Properties::AddItem( Window_0_Properties, "Width:", #PB_GadgetType_Spin )
      Properties::AddItem( Window_0_Properties, "Height:", #PB_GadgetType_Spin )
      
      Properties::AddItem( Window_0_Properties, "Other:", #False )
      Properties::AddItem( Window_0_Properties, "Flag:", #PB_GadgetType_Tree|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Font:", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Image:", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Puth", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Color:", #PB_GadgetType_String|#PB_GadgetType_Button )
      
      ResizeGadget(Window_0_Properties,#PB_Ignore,h,#PB_Ignore,300-h)
      BindEvent(#PB_Event_SizeWindow, @Window_0_Size_Event(), Window_0)
      BindEvent(#PB_Event_Gadget, @Window_0_Event(), Window_0)
    EndIf
    ProcedureReturn Window_0
  EndProcedure
  
  Procedure Window_0_Size_Event()
    Protected WindowWidth = WindowWidth(Window_0)
    Protected WindowHeight = WindowHeight(Window_0)
    Properties::Size(WindowWidth, WindowHeight-GadgetY(Window_0_Properties))
  EndProcedure
  
  Procedure Window_0_Event()
    Protected Object
    
    Select Event()
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_Change
            Select EventGadget()
              Case Window_0_Select
                Object = GetGadgetItemData(EventGadget(), GetGadgetState(EventGadget()))
                
                If IsGadget(Object)
                  Properties::Init(Object, GetGadgetText(EventGadget()), Properties::GetPBFlags(GadgetType(EventGadget())))
                ElseIf IsWindow(Object)
                  Properties::Init(Object, GetWindowTitle(EventWindow()), Properties::GetPBFlags())
                EndIf
            EndSelect
        EndSelect
    EndSelect
  EndProcedure
  
  
  Window_0_Open()
  
  Form_Open(#PB_Window_SystemMenu|#PB_Window_SizeGadget)
  
  While IsWindow(Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ----------------------------
; EnableXP