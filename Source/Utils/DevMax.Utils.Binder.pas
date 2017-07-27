unit DevMax.Utils.Binder;

interface

uses
  System.Classes, System.SysUtils, Data.Bind.DBScope;

type
  TDataBinder = class
  private
    class procedure BindPropControl(AControl: TComponent; AProperty: string; ASourceDB: TBindSourceDB; AFieldName: string);
    class procedure BindEditControl(AControl: TComponent; AProperty: string; ASourceDB: TBindSourceDB; AFieldName: string);
  public
    class procedure BindValue(AControl: TComponent; AProperty, AValue: string);
    class procedure BindControl(AControl: TComponent; AProperty: string; ASourceDB: TBindSourceDB; AFieldName: string);
//    class procedure BindList(AControl: TComponent; AProperty: string; ASourceDB: TBindSourceDB; AFieldName: string; FillList: TArray<TKeyValue>);
  end;

implementation

uses
  System.Rtti, Data.Bind.Components, FMX.ActnList;

{ TDataBinder }

class procedure TDataBinder.BindValue(AControl: TComponent; AProperty,
  AValue: string);
var
  context: TRttiContext;
begin
  context
    .GetType(AControl.ClassType)
    .GetProperty(AProperty)
    .SetValue(AControl, AValue);
end;

class procedure TDataBinder.BindControl(AControl: TComponent; AProperty: string;
  ASourceDB: TBindSourceDB; AFieldName: string);
begin
  // 수정가능한 컨트롤인지 판단
    // 더 깔끔한 조건이면 더 좋음
    // 델파이 업그레이드 시 검토 필요
  if Supports(AControl, ICaption) then
    BindPropControl(AControl, AProperty, ASourceDB, AFieldName)
  else
    BindEditControl(AControl, AProperty, ASourceDB, AFieldName);

//  if AControl.Observers.CanObserve(TControlObserver.IDEditLinkObserver) then
//    BindEditControl(AControl, AProperty, ASourceDB, AFieldName)
//  else
//    BindPropControl(AControl, AProperty, ASourceDB, AFieldName)
//  ;
end;

class procedure TDataBinder.BindEditControl(AControl: TComponent;
  AProperty: string; ASourceDB: TBindSourceDB; AFieldName: string);
var
  Link: TLinkControlToField;
begin
  Link := TLinkControlToField.Create(AControl);
  Link.DataSource := ASourceDB;
  Link.FieldName := AFieldName;
  Link.Control := AControl;
  Link.Active := Assigned(ASourceDB) and ASourceDB.DataSet.Active;
end;

class procedure TDataBinder.BindPropControl(AControl: TComponent;
  AProperty: string; ASourceDB: TBindSourceDB; AFieldName: string);
var
  Link: TLinkPropertyToField;
begin
  Link := TLinkPropertyToField.Create(AControl);
  Link.DataSource := ASourceDB;
  Link.FieldName := AFieldName;
  Link.Component := AControl;
  Link.ComponentProperty := AProperty;
  Link.Active := Assigned(ASourceDB) and ASourceDB.DataSet.Active;
end;

end.
