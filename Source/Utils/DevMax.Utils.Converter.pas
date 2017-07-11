unit DevMax.Utils.Converter;

interface

uses
  System.SysUtils, System.Classes,
  Data.DB, Data.FmtBcd, System.JSON, System.IOUtils;

type
  TDataConverter = class
  public
    class procedure DataSetToJSONObject(ADataSet: TDataSet; AJSONObject: TJSONObject); overload;
    class procedure DataSetToJSONObject(ADataSet: TDataSet;
  AFields: TArray<string>; AJSONObject: TJSONObject); overload;
  end;

implementation

{ TDataConverter }

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

end.
