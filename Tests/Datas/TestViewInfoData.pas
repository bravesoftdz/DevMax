unit TestViewInfoData;

interface

uses
  DevMax.Types, DevMax.Types.ViewInfo,
  FMX.Types;

function TestJsonString: string;
function GetViewInfoData: TViewInfo;

implementation

function TestJsonString: string;
var
  s: string;
begin
  s := '';
  s := s + '{';
  s := s + '  "VIEW_ID":"V00000000001",';
  s := s + '  "MAIN_PAGE_ID":null,';
  s := s + '  "ALIGN":"3",';
  s := s + '  "Pages":';
  s := s + '  [';
  s := s + '    {';
  s := s + '      "PAGE_ID":"P00000000001",';
  s := s + '      "ViewItems":';
  s := s + '      [';
  s := s + '        {';
  s := s + '          "ITEM_ID":"I00000000001",';
  s := s + '          "ITEM_CLS_ID":"ToolbarRightButton",';
  s := s + '          "ALIGN":1,';
  s := s + '          "HEIGHT":null';
  s := s + '        },';
  s := s + '        {';
  s := s + '          "ITEM_ID":"I00000000002",';
  s := s + '          "ITEM_CLS_ID":"TestViewItem",';
  s := s + '          "ALIGN":9,';
  s := s + '          "HEIGHT":null';
  s := s + '        }';
  s := s + '      ]';
  s := s + '    },';
  s := s + '    {';
  s := s + '      "PAGE_ID":"P00000000002",';
  s := s + '      "ViewItems":';
  s := s + '      [';
  s := s + '        {';
  s := s + '          "ITEM_ID":"I00000000003",';
  s := s + '          "ITEM_CLS_ID":"ToolbarRightButton",';
  s := s + '          "ALIGN":1,';
  s := s + '          "HEIGHT":null';
  s := s + '        },';
  s := s + '        {';
  s := s + '          "ITEM_ID":"I00000000004",';
  s := s + '          "ITEM_CLS_ID":"ListBox",';
  s := s + '          "ALIGN":9,';
  s := s + '          "HEIGHT":null,';
  s := s + '          "ViewItems":';
  s := s + '          [';
  s := s + '            {';
  s := s + '              "ITEM_ID":"I00000000005",';
  s := s + '              "ITEM_CLS_ID":"ListBoxItemRightText",';
  s := s + '              "ALIGN":0,';
  s := s + '              "HEIGHT":null';
  s := s + '            },';
  s := s + '            {';
  s := s + '              "ITEM_ID":"I00000000006",';
  s := s + '              "ITEM_CLS_ID":"ListBoxItemRightText",';
  s := s + '              "ALIGN":0,';
  s := s + '              "HEIGHT":null';
  s := s + '            }';
  s := s + '          ]';
  s := s + '        }';
  s := s + '      ]';
  s := s + '    }';
  s := s + '  ]';
  s := s + '}';

  Result := s;
end;

function GetViewInfoData: TViewInfo;
var
  ViewInfo: TViewInfo;
begin
  ViewInfo.VIEW_ID := 'V00000000001';
  ViewInfo.MAIN_PAGE_ID := 'P00000000001';

  SetLength(ViewInfo.ViewPages, 2);

  ViewInfo.ViewPages[0].PAGE_ID := 'P00000000001';
//  SetLength(ViewInfo.ViewPages[0].ViewItems, 2);
//
//  ViewInfo.ViewPages[0].ViewItems[0].ITEM_ID := 'I00000000001';
//  ViewInfo.ViewPages[0].ViewItems[0].ITEM_CLS_ID := 'ToolbarRightButton';
//  ViewInfo.ViewPages[0].ViewItems[0].ALIGN := TAlignLayout.Top; // 1
//
//  ViewInfo.ViewPages[0].ViewItems[1].ITEM_ID := 'I00000000002';
//  ViewInfo.ViewPages[0].ViewItems[1].ITEM_CLS_ID := 'TestViewItem';
//  ViewInfo.ViewPages[0].ViewItems[1].ALIGN := TAlignLayout.Client;  // 9
//
//  SetLength(ViewInfo.ViewPages[0].Bindings.ValueBindings, 1);
//  ViewInfo.ViewPages[0].Bindings.ValueBindings[0].ITEM_ID := 'I00000000001';
//  ViewInfo.ViewPages[0].Bindings.ValueBindings[0].ControlName := 'TitleLabel';
//  ViewInfo.ViewPages[0].Bindings.ValueBindings[0].Value := 'Runtime Test';

  ViewInfo.ViewPages[1].PAGE_ID := 'P00000000002';
  SetLength(ViewInfo.ViewPages[1].ViewItems, 2);

  ViewInfo.ViewPages[1].ViewItems[0].ITEM_ID := 'I00000000003';
  ViewInfo.ViewPages[1].ViewItems[0].ITEM_CLS_ID := 'ToolbarRightButton';
  ViewInfo.ViewPages[1].ViewItems[0].ALIGN := TAlignLayout.Top;

  ViewInfo.ViewPages[1].ViewItems[1].ITEM_ID := 'I00000000004';
  ViewInfo.ViewPages[1].ViewItems[1].ITEM_CLS_ID := 'ListBox';
  ViewInfo.ViewPages[1].ViewItems[1].ALIGN := TAlignLayout.Client;

  SetLength(ViewInfo.ViewPages[1].ViewItems[1].ViewItems, 2);
  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[0].ITEM_ID := 'I00000000005';
  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[0].ITEM_CLS_ID := 'ListBoxItemRightText.Image';
//  ViewInfo.Pages[1].ViewItems[1].ViewItems[0].Align := TAlignLayout.Client;

  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[1].ITEM_ID := 'I00000000006';
  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[1].ITEM_CLS_ID := 'ListBoxItemRightText.RightText';
//  ViewInfo.Pages[1].ViewItems[1].ViewItems[1].Align := TAlignLayout.Client;


  SetLength(ViewInfo.ViewPages[1].Bindings.FieldBindings, 1);
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].DataName := 'Employee';
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].FieldName := 'name';
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].ITEM_ID := 'I00000000003';
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].ControlName := 'TitleLabel';


  Result := ViewInfo;
end;

end.
