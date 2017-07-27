unit DevMax.Utils.Marshalling;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.TypInfo,
  Data.DB, Data.FmtBcd, System.JSON, System.IOUtils;

type
{
  필드이름 정의 특성
   - JSON Marshalling 시 구조체 필드이름으로 JSON 속성 매칭
     필드이름과 JSON 속성 명이 다른 경우, 필드 위에 (JSON 속성명으로)특성 선언
   - e.g. ViewPages -> Pages
    [FieldNameDef('Pages')]
    ViewPages: TArray<TViewPageInfo>;
}
  FieldNameDefAttribute = class(TCustomAttribute)
  private
    FFieldName: string;
  public
    constructor Create(const AFieldName: string);
    property FieldName: string read FFieldName;
  end;

  TJSONObjectEvent = reference to procedure(AObj: TJSONObject);

  TMarshall = class
  private
    /// 구조체(ARecord, ARecordInstance)의 필드(AField)에 JSON값으로 값을 채운다.
    class procedure SetRecordFieldFromJSONValue(var ARecord; AField: TRttiField; AJSONValue: TJSONValue; AValueName: string = ''); overload;
    class procedure SetRecordFieldFromJSONValue(ARecordInstance: Pointer; AField: TRttiField; AJSONValue: TJSONValue; AValueName: string = ''); overload;

    class procedure SetRecordFieldsFromJSONValue(ARecordInstance: Pointer; AField: TRttiField; AJSONValue: TJSONValue); overload;

    /// 구조체의 동적 배열 필드에 JSON배열의 값으로 길이 설정 후 값을 채운다.
    class procedure SetRecordDynArrayFromJSONArray(ARecordInstance: Pointer; AArrField: TRttiField; AJSONArray: TJSONArray);

    /// 필드 이름을 특성(FieldNameAttribute) 또는 Field.Name으로 반환
    class function GetFieldName(AField: TRttiField): string;
  public
    // DataSet & JSON
    /// 하나의 레코드를 JSONObject로 변환
    class procedure DataSetToJSONObject(ADataSet: TDataSet; AJSONObject: TJSONObject); overload;
    class procedure DataSetToJSONObject(ADataSet: TDataSet;
            AFields: TArray<string>; AJSONObject: TJSONObject); overload;

    // 데이터셋의 모든 레코드를 JSONArray로 변환
    class procedure DataSetToJSONArray(ADataSet: TDataSet; AJSONArray: TJSONArray; AJSONObjectProc: TJSONObjectEvent = nil); overload;
    class procedure DataSetToJSONArray(ADataSet: TDataSet;
            AFields: TArray<string>; AJSONArray: TJSONArray; AJSONObjectProc: TJSONObjectEvent = nil); overload;

    // JSON & Record
    /// JSON의 데이터로 구조체에 값을 채운다(동적 배열 포함)
    class procedure JSONToRecord<T>(AJSONValue: TJSONValue;
  var ARecord: T);
  end;

implementation

{ FieldNameAttribute }

constructor FieldNameDefAttribute.Create(const AFieldName: string);
begin
  FFieldName := AFieldName;
end;

{ TDataConverter }

class procedure TMarshall.DataSetToJSONArray(ADataSet: TDataSet;
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

class procedure TMarshall.DataSetToJSONArray(ADataSet: TDataSet;
  AFields: TArray<string>; AJSONArray: TJSONArray; AJSONObjectProc: TJSONObjectEvent = nil);
var
  Obj: TJSONObject;
begin
  { TODO : 열려있지 않은 경우 예외처리 필요 }

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

class procedure TMarshall.DataSetToJSONObject(ADataSet: TDataSet;
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

class procedure TMarshall.DataSetToJSONObject(ADataSet: TDataSet;
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

      // Boolean
      TFieldType.ftBoolean:
        if Field.AsBoolean then
          AJSONObject.AddPair(Field.FieldName, TJSONTrue.Create)
        else
          AJSONObject.AddPair(Field.FieldName, TJSONFalse.Create);
    end;
  end;
end;

// 구조체의 이름과 JSON 포맷의 이름이 다른 경우 FileNameAttribute에 JSON 포맷의 이름 지정 할 것
class function TMarshall.GetFieldName(AField: TRttiField): string;
var
  Attr: TCustomAttribute;
begin
  Result := AField.Name;
  for Attr in AField.GetAttributes do
  begin
    if Attr is FieldNameDefAttribute then
      Result := FieldNameDefAttribute(Attr).FieldName
  end;
end;

// Dynamic Array에 JSON Array 데이터 담기
{
  TViewInfo = reocord           // Record
    Pages: TArray<TViewPage>;   // Dynamic Array(ElmType: TViewPage)
  end;
}
class procedure TMarshall.SetRecordDynArrayFromJSONArray(ARecordInstance: Pointer;
  AArrField: TRttiField; AJSONArray: TJSONArray);
var
  I: Integer;
  Len: NativeInt; // 꼭 NativeInt로 적용(64비트 대응: iOS64 등)
  Ctx: TRttiContext;
  RecVal, ItemVal: TValue;
  JSONVal: TJSONValue;
  RecRawData, ItemRawData: Pointer;
  ElmType: PTypeInfo;
  Field: TRttiField;
  FieldName: string;
begin
  RecVal := AArrField.GetValue(ARecordInstance);
  if not RecVal.IsArray then
    Exit;

  RecRawData := RecVal.GetReferenceToRawData; // 배열의 데이터 포인터
  Len := AJSONArray.Count;
  // 동적배열 길이 설정
  DynArraySetLength(PPointer(RecRawData)^, RecVal.TypeInfo, 1, @Len);
  AArrField.SetValue(ARecordInstance, RecVal); // SetValue 설정 안하면 원래 레코드에 적용 안됨

  // 배열 요소의 타입
  ElmType := RecVal.TypeData.DynArrElType^;

  Ctx := TRttiContext.Create;
  try
    for I := 0 to Len - 1 do
    begin
      JSONVal := AJSONArray.Items[I];
      ItemVal := RecVal.GetArrayElement(I);
      ItemRawData := ItemVal.GetReferenceToRawData;
      for Field in Ctx.GetType(ElmType).GetFields do
      begin
        FieldName := GetFieldName(Field);
        SetRecordFieldFromJSONValue(ItemRawData, Field, JSONVal, FieldName);
      end;
      RecVal.SetArrayElement(I, ItemVal); // SetArrayElement 안하면 원래 레코드에 적용 안됨
    end;
  finally
    Ctx.Free;
  end;
end;

/// SetRecordFieldFromJSONValue
class procedure TMarshall.SetRecordFieldFromJSONValue(ARecordInstance: Pointer;
  AField: TRttiField; AJSONValue: TJSONValue; AValueName: string);
var
  OrdValue: Integer;
begin
  case AField.FieldType.TypeKind of
    tkString, tkLString, tkWString, tkUString:
      AField.SetValue(ARecordInstance, TValue.From<string>(AJSONValue.GetValue<string>(AValueName)));
    tkInteger, tkInt64:
      AField.SetValue(ARecordInstance, TValue.From<Integer>(AJSONValue.GetValue<Integer>(AValueName, -1)));
    tkFloat:
      AField.SetValue(ARecordInstance, TValue.From<Single>(AJSONValue.GetValue<Single>(AValueName, -1)));
    tkEnumeration:
      begin
        if not AJSONValue.TryGetValue<Integer>(AValueName, OrdValue) then
        begin
          // 열거형 문자열인 경우 처리(taRight 등)
          OrdValue := GetEnumValue(AField.FieldType.Handle,
                          AJSONValue.GetValue<string>(AValueName)); // 열거형 문자열을 숫자로 전환
        end;

        if OrdValue < 0 then
          Exit;

        AField.SetValue(ARecordInstance, TValue.FromOrdinal(AField.FieldType.Handle, OrdValue));
      end;
    tkDynArray:
      begin
        // JSON Array
        if AValueName <> '' then
          AJSONValue := AJSONValue.GetValue<TJSONValue>(AValueName, nil);
        if Assigned(AJSONValue) then
          SetRecordDynArrayFromJSONArray(ARecordInstance, AField, AJSONValue as TJSONArray);
      end;
    tkRecord:
      begin
        if AValueName <> '' then
          AJSONValue := AJSONValue.GetValue<TJSONValue>(AValueName, nil);
        if Assigned(AJSONValue) then
          SetRecordFieldsFromJSONValue(ARecordInstance, AField, AJSONValue);
      end;
    { TODO: 필요한 필드타입 추가 구현 할 것 }
    else
      raise Exception.Create('Not support type: ' + AField.FieldType.ToString);
  end;
end;

class procedure TMarshall.SetRecordFieldsFromJSONValue(ARecordInstance: Pointer; AField: TRttiField; AJSONValue: TJSONValue);
var
  Ctx: TRttiContext;
  Field: TRttiField;
  FieldName: string;
  RecVal: TValue;
//  JSONValue: TJSONValue;
begin
  Ctx := TRttiContext.Create;
  try
    RecVal := AField.GetValue(ARecordInstance);

    for Field in Ctx.GetType(RecVal.TypeInfo).GetFields do
    begin
      FieldName := GetFieldName(Field);
      SetRecordFieldFromJSONValue(RecVal.GetReferenceToRawData, Field, AJSONValue, FieldName);
    end;
    AField.SetValue(ARecordInstance, RecVal);
  finally
    Ctx.Free;
  end;
end;

class procedure TMarshall.SetRecordFieldFromJSONValue(var ARecord; AField: TRttiField; AJSONValue: TJSONValue; AValueName: string = '');
begin
  SetRecordFieldFromJSONValue(@ARecord, AField, AJSONValue, AValueName);
end;

class procedure TMarshall.JSONToRecord<T>(AJSONValue: TJSONValue;
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
      if not AJSONValue.TryGetValue<TJSONValue>(FieldName, Value) then
        Continue;

      SetRecordFieldFromJSONValue(ARecord, Field, Value);
    end;
  finally
    Ctx.Free;
  end;

end;

end.
