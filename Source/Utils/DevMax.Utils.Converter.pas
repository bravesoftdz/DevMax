unit DevMax.Utils.Converter;

interface

uses
  DevMax.Types.ViewInfo, // 요기 있는게 맞나?(Need Refectoring)
  FMX.Types,
  System.SysUtils, System.Classes, System.Rtti, System.TypInfo,
  Data.DB, Data.FmtBcd, System.JSON, System.IOUtils;

type
  TJSONObjectEvent = reference to procedure(AObj: TJSONObject);

  TDataConverter = class
  private
    class procedure SetFieldValueFromJSONValue(var ARecord; AField: TRttiField; AValue: TJSONValue; AValueName: string = ''); overload;
    class procedure SetFieldValueFromJSONValue(AInstance: Pointer; AField: TRttiField; AValue: TJSONValue; AValueName: string = ''); overload;
    class procedure SetDynArrayFromJSONArray(AInstance: Pointer;
  AField: TRttiField; AValue: TJSONValue); static;
    class function GetFieldName(AField: TRttiField): string;
  public
    // DataSet & JSON
    class procedure DataSetToJSONObject(ADataSet: TDataSet; AJSONObject: TJSONObject); overload;
    class procedure DataSetToJSONObject(ADataSet: TDataSet;
            AFields: TArray<string>; AJSONObject: TJSONObject); overload;

    class procedure DataSetToJSONArray(ADataSet: TDataSet; AJSONArray: TJSONArray; AJSONObjectProc: TJSONObjectEvent = nil); overload;
    class procedure DataSetToJSONArray(ADataSet: TDataSet;
            AFields: TArray<string>; AJSONArray: TJSONArray; AJSONObjectProc: TJSONObjectEvent = nil); overload;

    // JSON & Record
    class procedure JSONToRecord<T>(AObj: TJSONObject; var ARecord: T);
  end;

implementation

{ TDataConverter }

class procedure TDataConverter.DataSetToJSONArray(ADataSet: TDataSet;
  AJSONArray: TJSONArray; AJSONObjectProc: TJSONObjectEvent = nil);
var
  I: Integer;
  Fields: TArray<string>;
begin
  SetLength(Fields, ADataSet.FieldCount);
  for I := 0 to ADataSet.FieldCount - 1 do
    Fields[I] := ADataSet.Fields[I].FieldName;

  DataSetToJSONArray(ADataSet, Fields, AJSONArray, AJSONObjectProc);
end;

class procedure TDataConverter.DataSetToJSONArray(ADataSet: TDataSet;
  AFields: TArray<string>; AJSONArray: TJSONArray; AJSONObjectProc: TJSONObjectEvent = nil);
var
  Obj: TJSONObject;
begin
  ADataSet.First;
  while not ADataSet.Eof do
  begin
    Obj := TJSONObject.Create;

    DataSetToJSONObject(ADataSet, AFields, Obj);
    AJSONArray.AddElement(Obj);

    if Assigned(AJSONObjectProc) then
      AJSONObjectProc(Obj);

    ADataSet.Next;
  end;
end;

class procedure TDataConverter.DataSetToJSONObject(ADataSet: TDataSet;
  AJSONObject: TJSONObject);
var
  I: Integer;
  Fields: TArray<string>;
begin
  SetLength(Fields, ADataSet.FieldCount);
  for I := 0 to ADataSet.FieldCount - 1 do
    Fields[I] := ADataSet.Fields[I].FieldName;

  DataSetToJSONObject(ADataSet, Fields, AJSONObject);
end;

class procedure TDataConverter.DataSetToJSONObject(ADataSet: TDataSet;
  AFields: TArray<string>; AJSONObject: TJSONObject);
var
  I: Integer;
  Field: TField;
begin
  for I := 0 to Length(AFields) - 1 do
  begin
    Field := ADataSet.FieldByName(AFields[I]);
    if not Assigned(Field) then
      Continue;

    if Field.IsNull then
    begin
      AJSONObject.AddPair(Field.FieldName, TJSONNull.Create);
      Continue;
    end;

    case Field.DataType of
      // Numeric
      TFieldType.ftInteger, TFieldType.ftLongWord, TFieldType.ftAutoInc, TFieldType.ftSmallint,
        TFieldType.ftShortint:
        AJSONObject.AddPair(Field.FieldName, TJSONNumber.Create(Field.AsInteger));
      TFieldType.ftLargeint:
        AJSONObject.AddPair(Field.FieldName, TJSONNumber.Create(Field.AsLargeInt));

      // Float
      TFieldType.ftSingle, TFieldType.ftFloat:
        AJSONObject.AddPair(Field.FieldName, TJSONNumber.Create(Field.AsFloat));
      TFieldType.ftCurrency:
        AJSONObject.AddPair(Field.FieldName, TJSONNumber.Create(Field.AsCurrency));
      TFieldType.ftBCD, TFieldType.ftFMTBcd:
        AJSONObject.AddPair(Field.FieldName, TJSONNumber.Create(BcdToDouble(Field.AsBcd)));

      // string
      ftWideString, ftMemo, ftWideMemo:
        AJSONObject.AddPair(Field.FieldName, Field.AsWideString);
      ftString:
        AJSONObject.AddPair(Field.FieldName, Field.AsString);

      // Date
      TFieldType.ftDate:
        AJSONObject.AddPair(Field.FieldName, FormatDateTime('YYYY-MM-DD', Field.AsDateTime));
      TFieldType.ftDateTime:
        AJSONObject.AddPair(Field.FieldName, FormatDateTime('YYYY-MM-DD HH:NN:SS', Field.AsDateTime));

      // boolean
      TFieldType.ftBoolean:
        if Field.AsBoolean then
          AJSONObject.AddPair(Field.FieldName, TJSONTrue.Create)
        else
          AJSONObject.AddPair(Field.FieldName, TJSONFalse.Create);
    end;
  end;
end;

// 구조체의 이름과 JSON 포맷의 이름이 다른 경우 FileNameAttribute에 JSON 포맷의 이름 지정 할 것
class function TDataConverter.GetFieldName(AField: TRttiField): string;
var
  Attr: TCustomAttribute;
begin
  Result := AField.Name;
    for Attr in AField.GetAttributes do
    begin
      if Attr is FieldNameAttribute then
        Result := FieldNameAttribute(Attr).FieldName
    end;
end;

class procedure TDataConverter.SetDynArrayFromJSONArray(AInstance: Pointer;
  AField: TRttiField; AValue: TJSONValue);
var
  Ctx: TRttiContext;
  I, Len: Integer;
  RecVal, ItemVal: TValue;
  ItemRawData: Pointer;
  JSONArr: TJSONArray;
  JSONVal: TJSONValue;
  RawData: Pointer;
  ArrType: PTypeInfo;
  Field: TRttiField;
  FieldName: string;
begin
  RecVal := AField.GetValue(AInstance);
  if not RecVal.IsArray then
    Exit;

  if not (AValue is TJSONArray) then
    Exit;

  JSONArr := AValue as TJSONArray;

  RawData := RecVal.GetReferenceToRawData; // 배열의 데이터 포인터
  Len := JSONArr.Count;
  // 동적배열 길이 설정
  DynArraySetLength(PPointer(RawData)^, RecVal.TypeInfo, 1, @Len);
  AField.SetValue(AInstance, RecVal); // SetValue 설정 안하면 원래 레코드에 적용 안됨

  // 배열 요소의 타입
  ArrType := RecVal.TypeData.DynArrElType^;

  Ctx := TRttiContext.Create;
  try
    for I := 0 to Len - 1 do
    begin
      JSONVal := JSONArr.Items[I];
      ItemVal := RecVal.GetArrayElement(I);
      ItemRawData := ItemVal.GetReferenceToRawData;
      for Field in Ctx.GetType(ArrType).GetFields do
      begin
        FieldName := GetFieldName(Field);
        Log.d(FieldName);
        SetFieldValueFromJSONValue(ItemRawData, Field, JSONVal, FieldName);
      end;
      RecVal.SetArrayElement(I, ItemVal); // SetArrayElement 안하면 원래 레코드에 적용 안됨
    end;
  finally
    Ctx.Free;
  end;
end;

class procedure TDataConverter.SetFieldValueFromJSONValue(AInstance: Pointer;
  AField: TRttiField; AValue: TJSONValue; AValueName: string);
var
  OrdValue: Integer;
begin
//  AValue.TryGetValue()

  case AField.FieldType.TypeKind of
    tkString, tkLString, tkWString, tkUString:
      AField.SetValue(AInstance, TValue.From<string>(AValue.GetValue<string>(AValueName)));
    tkInteger, tkInt64:
      AField.SetValue(AInstance, TValue.From<Integer>(AValue.GetValue<Integer>(AValueName, -1)));
    tkFloat:
      AField.SetValue(AInstance, TValue.From<Single>(AValue.GetValue<Single>(AValueName, -1)));
    tkEnumeration:
      begin
        if not AValue.TryGetValue<Integer>(AValueName, OrdValue) then
        begin
          // 열거형 문자열인 경우 처리(taRight 등)
          OrdValue := GetEnumValue(AField.FieldType.Handle,
                          AValue.GetValue<string>(AValueName)); // 열거형 문자열을 숫자로 전환
        end;

        if OrdValue < 0 then
          Exit;

        AField.SetValue(AInstance, TValue.FromOrdinal(AField.FieldType.Handle, OrdValue));
      end;
    tkDynArray:
      begin
        if AValueName <> '' then
          AValue := AValue.GetValue<TJSONValue>(AValueName, nil);
        SetDynArrayFromJSONArray(AInstance, AField, AValue);
      end;
    tkRecord:
      ;
    else
      raise Exception.Create('Not support type: ' + AField.FieldType.ToString);
  end;
end;

class procedure TDataConverter.SetFieldValueFromJSONValue(var ARecord; AField: TRttiField; AValue: TJSONValue; AValueName: string = '');
begin
  SetFieldValueFromJSONValue(@ARecord, AField, AValue, AValueName);
end;

class procedure TDataConverter.JSONToRecord<T>(AObj: TJSONObject;
  var ARecord: T);

var
  Ctx: TRttiContext;
  Field: TRttiField;
  Value: TJSONValue;
  FieldName: string;
begin
  Ctx := TRttiContext.Create;
  try
    for Field in Ctx.GetType(TypeInfo(T)).GetFields do
    begin
      FieldName := GetFieldName(Field);
      Value := AObj.Values[FieldName];
      if not Assigned(Value) then
        raise Exception.CreateFmt('Not found field.(Name: %s)', [FieldName]);

      SetFieldValueFromJSONValue(ARecord, Field, Value);
    end;
  finally
    Ctx.Free;
  end;

end;

end.
