unit Assis.Json;

/// Extends primitive type string to handle itself as a Json
/// Introduces the type Json = string with a lot of Json features
///
/// <remarks>
/// With this unit you can instantiate a JSON with one line of code
/// var Amount: Double;
/// var JAmount: Json;
/// begin
/// JAmount.Read(Amount);
/// end;
///
///  >>output {"amount": 0.00}
/// </remarks>
///
{$REGION 'Author'}
/// var Properties := '{"author": "Ricardo da Rocha", "Licence": "Free"}
/// Properties.value['Furthermore'] := 'Contribute by e-mail ricardodarocha@outlook.com';
{$ENDREGION}

interface

uses Classes, Sysutils, DateUtils, Generics.Collections,

  /// Uses record helper for string  |ArrayOfStrings, ListOfStrings, etc
  //Assis.Strings,

  /// Uses Delphi Json
  System.Json, Rest.Json, Rest.Json.Types,

  /// Uses Rtti
  System.Rtti, System.TypInfo,

  /// Uses Controls
  VCL.Forms, VCL.StdCtrls, VCL.ExtCtrls,

  /// Uses Datasets
  Data.Db,

  /// Uses Teechart
  VCLTee.TeEngine, VCLTee.Series, VCLTee.Chart;

type
  ListOfStrings = array of string;  //it allows you use array of string as typed array. See ListOfStringAssistent

const
  EmptyJson = '{}';
  EmptyArray = '[]';

type
  Json = string;

  JsonAssistent = record helper for Json
    /// <summary>
    ///   make an empty json {}
    /// </summary>
    procedure Clear;

    /// <summary>
    ///   make an json template based on format('',[])
    ///   example var Airplain: Json;
    ///   Airplan.template('{"Model": "%s", "Origin": "%s", "ID": "%s", "Description": "%s"}',
    ///                     ['Embraer KC-390', 'Brasil','KC-390', 'Transporte multimiss�o'])
    /// </summary>
    procedure template(value: string; const args: array of const);

    /// <summary>
    ///   use ADD to add pair of any kind you want
    /// </summary>
    procedure Add(key: string; value: integer); overload;
    procedure Add(key: string; value: int64); overload;
    procedure Add(key: string; value: extended); overload;
    procedure Add(key: string; value: boolean); overload;

    /// <remarks>
    ///   inplicit types will detect json types automatically
    /// </remarks>
    procedure Add(key, value: string; inplicit: boolean = true); overload;

    /// <summary>
    /// Dinamically add an ITEM of a Json Array. See StartArray and CloseArray
    /// </summary>
    procedure AddArrayItem(value: Json; quebraLinha: String = #13); overload;
    procedure AddArrayItem(value: TObject; quebraLinha: String = #13); overload;
    procedure StartArray;
    procedure CloseArray;
    // procedure Add(key: string; value: date); overload;

    /// <summary>
    /// Instantiate and returns a JSONObject based on String, if string contais a valid json
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>
    function asJsonObject: TJsonObject;

    /// <summary>
    /// Instantiate and returns a JSONValue based on String, if string contais a valid json
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>
    function asJsonValue: TJsonValue;

    /// <summary>
    ///  NOT YET IMPLEMENTED
    /// Instantiate and returns a JSONPair based on String, if string contais a valid json
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>
    function asJsonPair: TJsonPair;

    /// <summary>
    /// Instantiate and returns a JSONArray based on String, if string contais a valid json array
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>
    function asJsonArray: TJsonArray;

    /// <summary>
    /// Instantiate and returns a JSONNumber based on String, if string contais a valid json Number
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>
    function asJsonNumber: TJsonNumber;

    /// <summary>
    /// Instantiate and returns a JSONString based on String, if string contais a valid json string
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>
    function asJsonString: TJsonString;

    /// <summary>
    /// Instantiate and returns a JSONBool based on String, if string contais a valid json  boolean true or false
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>>
    function asJsonBoolean: TJsonBool;

    // function asJsonExtended: TJsonObject;

    /// <summary>
    /// Instantiate and returns a JSONString formated as Date based on String, if string contais a valid json datetime
    /// </summary>
    /// <remarks>
    /// Check the JsonObject Instance is not yet free.
    /// � responsabilidade do cliente limpar esta inst�ncia da mem�ria .Free
    /// </remarks>
    function asJsonDate: TJsonObject;

    function asInteger: integer;
    function asInt64: int64;
    function asString: String;
    function asBoolean: boolean;
    function asCurrency: Currency;
    function asDouble: Double;
    function asDate: TDate;
    function asDateTime: TDateTime;
    function asTime: TTime;
    function asGUID: String; // {3561-5455...}
    function asID(SilentMode: boolean = true): String; // 3561-5455...

    function key: String;
    function Keys: ListOfStrings;
    function Values: ListOfStrings;

    procedure Read(value: integer); overload;
    procedure Read(value: int64); overload;
    procedure Read(value: String); overload;
    procedure Read(value: TStrings); overload;
    procedure ReadDate(value: TDate; Formato: String = 'dd/mm/yyyy'); overload;
    { Data: "", Dia: 23, Mes: 3, Ano: 2016, NomeMes: "Janeiro", Hora: "", formato: "dd/mm/yyyy" }
    procedure ReadDate(value: TDateTime; Formato: String = 'dd/mm/yyyy hh:nn:ss.zzz'); overload;
    { Data: "", Dia: 23, Mes: 3, Ano: 2016, NomeMes: "Janeiro", Hora: "", formato: "dd/mm/yyyy hh:nn:ss.zzz" }
    procedure ReadTime(value: TTime; Formato: String = 'hh:mm:ss'); overload;
    procedure Read(value: extended); overload;
    procedure Read(value: boolean); overload;
    procedure Read(var value: TObject); overload;
    procedure Read(key: String; value: integer); overload;
    procedure Read(key: String; value: int64); overload;
    procedure Read(key: String; value: String); overload;
    procedure Read(key: String; value: TStrings); overload;
    procedure ReadDate(key: String; value: TDate; Formato: String = 'dd/mm/yyyy'); overload;
    { Data: "", Dia: 23, Mes: 3, Ano: 2016, NomeMes: "Janeiro", Hora: "", formato: "dd/mm/yyyy" }
    procedure ReadDate(key: String; value: TDateTime; Formato: String = 'dd/mm/yyyy hh:nn:ss.zzz'); overload;
    { Data: "", Dia: 23, Mes: 3, Ano: 2016, NomeMes: "Janeiro", Hora: "", formato: "dd/mm/yyyy hh:nn:ss.zzz" }
    procedure ReadTime(key: String; value: TTime; Formato: String = 'hh:mm:ss'); overload;
    procedure Read(key: String; value: extended); overload;
    procedure Read(key: String; value: boolean); overload;
    procedure Read(key: String; value: TObject); overload;
    // procedure Read(Key: String; Value: TInterface); overload;
    procedure Read(key: String; value: TForm); overload;
    procedure Read(key: String; value: TPanel); overload;
    procedure Read(key: String; value: TDataset); overload;
    procedure Read(key: String; value: TChart); overload;

    // procedure Read(Value: TInterface); overload;
    procedure Read(value: TForm); overload;
    procedure Read(value: TPanel); overload;
    procedure Read(value: TChart); overload;
    // procedure Read(Value: TValue); overload;
    procedure Read(value: TDataset); overload;
  private
    function GetKey(Index: string = ''): String; overload;
    function GetKey(Index: integer): String; overload;
    function JsonObjectInstance(Parse: String): TJsonObject;
    function JsonInstance(Parse: String): TJsonValue;
    procedure SetKey(Index: string; const value: String);
  public
    property Value[Index: string]: String read GetKey write setKey{default};
    property &Set[Index: string]: String write SetKey {default};
  end;

  ListOfStringAssistent = record helper for ListOfStrings
     procedure clear;
     procedure add(Value: String);
  end;

  { Todo: Assis.Qira

    QiraJsonAssistent = class helper for Json

    function Read(Value: TIndicador): String
  }

implementation

{ JsonAssistent }

function JsonAssistent.JsonInstance(Parse: String): TJsonValue;
begin
  try
    result := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Parse), 0);
  except
    result := nil;
  end;
end;

function JsonAssistent.JsonObjectInstance(Parse: String): TJsonObject;
begin
  try
    result := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Parse), 0) as TJsonObject;
  except
    result := nil;
  end;
end;

// ----------------------------------------------------------------------------------------------

procedure JsonAssistent.AddArrayItem(value: Json; quebraLinha: String = #13);
begin
  if length(trim(self)) = 0 then
    self.StartArray
  else if trim(self[1]) <> '[' then
    self := '[' + self;

  if length(trim(self)) = 1 then
    self := self + value + quebraLinha
  else
    self := self + ',' + value + quebraLinha;

end;

procedure JsonAssistent.AddArrayItem(value: TObject; quebraLinha: String);
begin
  self.AddArrayItem(TJson.ObjectToJsonString(value), quebraLinha);
end;

procedure JsonAssistent.Add(key: string; value: string; inplicit: boolean = true);
var
  Objeto: TJsonObject;
begin
  if inplicit then
  begin
    Objeto := self.asJsonObject;
    if Json(value).asJsonValue is TJsonValue then
    begin
      Objeto.AddPair(key, Json(value).asJsonValue);
      self := Objeto.ToJSON;
    end
    else
      self := self.asJsonObject.AddPair(key, value).ToJSON;
  end
  else
    self := self.asJsonObject.AddPair(key, value).ToJSON;
end;

procedure JsonAssistent.Add(key: string; value: integer);
begin
  self := self.asJsonObject.AddPair(key, TJsonNumber.Create(value)).ToJSON
end;

procedure JsonAssistent.Add(key: string; value: int64);
begin
  self := self.asJsonObject.AddPair(key, TJsonNumber.Create(value)).ToJSON
end;

procedure JsonAssistent.Add(key: string; value: extended);
begin
  self := self.asJsonObject.AddPair(key, TJsonNumber.Create(value)).ToJSON
end;

// procedure JsonAssistent.Add(key: string; value: tdate);
// begin
// self := self.asJsonObject.Add(key, TJSONNumber.Create(value)).ToJSON
// end;

procedure JsonAssistent.Add(key: string; value: boolean);
begin
  if value then
    self := self.asJsonObject.AddPair(key, 'true').ToJSON
  else
    self := self.asJsonObject.AddPair(key, 'false').ToJSON;
end;

function JsonAssistent.asBoolean: boolean;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    result := false;

  &Message := '';
  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonBool then
      result := ((fInstance as TJsonValue) as TJsonBool).asBoolean
    else
      &Message := 'O json informado n�o � do tipo boolean|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asCurrency: Currency;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    result := (0.00);

  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonNumber then
      result := ((fInstance as TJsonValue) as TJsonNumber).asDouble
    else
      &Message := 'O json informado n�o � do tipo Currency|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asDate: TDate;
var
  &Message: String;
  fInstance: TJsonValue;
begin
  if trim(self) = EmptyStr then
    self.Read('{}');

  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonNumber then
      result := ((fInstance as TJsonNumber) as TJsonNumber).asInt
    else
      &Message := 'O json informado n�o � do tipo TDate|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);

end;

function JsonAssistent.asDateTime: TDateTime;
var
  &Message: String;
  fInstance: TJsonValue;
begin
  fInstance := JsonInstance(self);

  if (fInstance as TJsonValue) is TJsonNumber then
      result := ((fInstance as TJsonValue) as TJsonNumber).asDouble
  else
  if (fInstance as TJSONString)is TJSONString then
  begin
      try
        result := ISO8601ToDate((fInstance as TJsonString).toString)
      except
        result := 0;

      end;
  end else
  result := 0;
//      &Message := 'O json informado n�o � do tipo TDatetime|' + self;
//    free; // Limpa fInstance, que � o retorno de JsonInstance


  fInstance.Free;
  if &Message <> '' then
    raise Exception.Create(&Message);

end;

function JsonAssistent.asDouble: Double;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    result := (0.00);

  with JsonInstance(self) do
  begin
    if ((fInstance as TJsonValue) is TJsonNumber) then
      result := ((fInstance as TJsonValue) as TJsonNumber).asDouble
    else
      &Message := 'O json informado n�o � do tipo Double|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asGUID: String;
var
  &Message: String;
  G: TGuid;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    self := EmptyJson;

  &Message := '';

  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonString then
    begin
      try
        G := StringToGuid(((fInstance as TJsonValue) as TJsonString).value);
        result := Sysutils.Format('{%0.8X-%0.4X-%0.4X-%0.2X%0.2X-%0.2X%0.2X%0.2X%0.2X%0.2X%0.2X}',
          [G.D1, G.D2, G.D3, G.D4[0], G.D4[1], G.D4[2], G.D4[3], G.D4[4], G.D4[5], G.D4[6], G.D4[7]]);
      except
        on e: Exception do
          &Message := e.message;
      end;
    end
    else
      &Message := 'O json informado n�o � do tipo Guid|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);

end;

function JsonAssistent.asID(SilentMode: boolean = true): String;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  try
    result := stringreplace(stringreplace(self.asGUID, '{', '', [rfReplaceAll]), '}', '', [rfReplaceAll]);
  except
    if SilentMode then
      &Message := stringreplace(stringreplace(self, '{', '', [rfReplaceAll]), '}', '', [rfReplaceAll])
    else
      result := stringreplace(stringreplace(self, '{', '', [rfReplaceAll]), '}', '', [rfReplaceAll]) + '^invalid';
    // {  }
  end;
end;

function JsonAssistent.asInteger: integer;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    result := 0;

  with JsonInstance(self) do
  begin
    if ((fInstance as TJsonValue) is TJsonNumber) then
      result := ((fInstance as TJsonValue) as TJsonNumber).asInt
    else
      &Message := 'O json informado n�o � do tipo Integer|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asInt64: int64;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    result := 0;

  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonNumber then
      result := ((fInstance as TJsonValue) as TJsonNumber).asInt64
    else
      &Message := 'O json informado n�o � do tipo BigInt|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asJsonArray: TJsonArray;
var
  &Message: String;
  fInstance: TJsonValue;
begin

  fInstance := JsonInstance(self);

  if (fInstance as TJsonValue) is TJsonArray then
    result := (fInstance) as TJsonArray
    /// / o cliente deve limpar  esta instancia
  else
  begin
    &Message := 'O json informado n�o � do tipo JsonArray|' + self;
    result := nil;
  end;

  // if &Message <> '' then
  // raise Exception.Create(&message);
end;

function JsonAssistent.asJsonBoolean: TJsonBool;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonBool then
      result := (fInstance as TJsonValue) as TJsonBool
    else
      &Message := 'O json informado n�o � do tipo JsonBool|' + self;

    /// / o cliente deve limpar  esta instancia

  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asJsonDate: TJsonObject;
begin
    raise Exception.Create('Ainda n�o implementado. Not yet implemented');

end;

function JsonAssistent.asJsonNumber: TJsonNumber;

var
  &Message: String;
  fInstance: TJsonObject;
begin
  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonNumber then
      result := (fInstance as TJsonValue) as TJsonNumber
    else
      &Message := 'O json informado n�o � do tipo TJsonNumber|' + self;

    /// o cliente deve limpar esta instancia
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asJsonObject: TJsonObject;
var
  &Message: String;
  fInstance: TJsonObject;
begin

  if trim(self) = EmptyStr then
    self := EmptyJson;
  try
    fInstance := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(self), 0) as TJsonObject;

    if fInstance is TJsonObject then
      result := fInstance
      /// o cliente deve limpar esta instancia
    else
    begin
      fInstance.free;
      result := nil;
    end;

  except
    result := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes('{}'), 0) as TJsonObject;

  end;
  if &Message <> '' then
    raise Exception.Create(&Message);

end;

function JsonAssistent.asJsonPair: TJsonPair;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  // fInstance := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(self),0);

  raise Exception.Create('Ainda nao implementado');
end;

function JsonAssistent.asJsonString: TJsonString;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    self := EmptyJson;

  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonString then
      result := (fInstance as TJsonValue) as TJsonString
    else
      &Message := 'O json informado n�o � do tipo TJsonString|' + self;

    /// o cliente deve limpar esta instancia
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);

end;

function JsonAssistent.asJsonValue: TJsonValue;
var
  &Message: String;
  fInstance: TJsonValue;
begin
  if trim(self) = EmptyStr then
    self := EmptyJson;

  fInstance := JsonInstance(self);
  if fInstance is TJsonValue then
    result := fInstance as TJsonValue
  else
  begin
    fInstance.free;
    result := nil;
  end;

  /// o cliente deve limpar esta instancia

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asString: String;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  if trim(self) = EmptyStr then
    self := EmptyJson;

  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonString then
      result := ((fInstance as TJsonValue) as TJsonString).value
    else
      &Message := 'O json informado n�o � do tipo string|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);
end;

function JsonAssistent.asTime: TTime;
var
  &Message: String;
  fInstance: TJsonObject;
begin
  with JsonInstance(self) do
  begin
    if (fInstance as TJsonValue) is TJsonNumber then
      result := (((fInstance as TJsonValue) as TJsonValue) as TJsonNumber).asDouble -
        ((fInstance as TJsonValue) as TJsonNumber).asInt
    else
      &Message := 'O json informado n�o � do tipo Double|' + self;
    free; // Limpa fInstance, que � o retorno de JsonInstance
  end;

  if &Message <> '' then
    raise Exception.Create(&Message);

end;

procedure JsonAssistent.Clear;
begin
  self := EmptyJson;
end;

procedure JsonAssistent.CloseArray;
begin
  self := self + ']';
end;

function JsonAssistent.GetKey(Index: integer): String;
var
  fInstance: TJSONValue;
begin
  result := EmptyStr;
  fInstance := JsonInstance(self);

  if fInstance is TJsonObject then
    if (fInstance as TJsonObject).Count >= 0 then
      result := (fInstance as TJsonObject).Get(Index).ToJSON;

  fInstance.free;
end;

function JsonAssistent.GetKey(Index: string): String;
var
  fInstance: TJSONValue;
begin
  result := EmptyStr;
  fInstance := JsonInstance(self);
  try
    if fInstance is TJsonObject then
      if (fInstance as TJsonObject).Count >= 0 then
        if (fInstance as TJsonObject).GetValue(Index) <> nil then
          result := (fInstance as TJsonObject).GetValue(Index).ToJSON;
  finally
    fInstance.free;
  end;
end;

function JsonAssistent.key: String;
// Se o json tiver mais de um campo retorna o primeiro
begin
  result := self.GetKey(0);
end;

/// <summary>
/// Retorna todas as chaves que ele encontrar no JSON, desta forma � poss�vel iterar por todas as chaves sem conhec�-las
/// </summary>
function JsonAssistent.Keys: ListOfStrings;
var
  fInstance: TJSONValue;
  JsonPair: TJsonPair;
begin
  result.Clear;

  fInstance := JsonInstance(self);

  if fInstance is TJsonObject then
    if (fInstance as TJsonObject).Count >= 0 then
      for JsonPair in (fInstance as TJsonObject) do
        result.Add(JsonPair.JsonString.value);

end;

function JsonAssistent.Values: ListOfStrings;
var
  fInstance: TJSONValue;
  JsonPair: TJsonPair;
begin
  result.Clear;

  fInstance := JsonInstance(self);

  if fInstance is TJsonObject then
    if (fInstance as TJsonObject).Count >= 0 then
      for JsonPair in (fInstance as TJsonObject) do
        result.Add(JsonPair.JsonValue.value);

end;

procedure JsonAssistent.Read(value: TStrings);
begin
  { todo: import unit Assis.jsondelimited }
  /// Eu ainda n�o terminei de implementar para ler o JSON de TStrings
  raise Exception.Create('Ainda nao implementado');
end;

procedure JsonAssistent.ReadDate(value: TDate; Formato: String);
begin
  self.ReadDate('data', value, Formato);
end;

procedure JsonAssistent.ReadDate(value: TDateTime; Formato: String);
begin
  self.ReadDate('data', value, Formato);
end;

procedure JsonAssistent.Read(value: integer);
begin
  self.Read('valor', value);
end;

procedure JsonAssistent.Read(value: int64);
begin
  self.Read('valor', value);
end;

procedure JsonAssistent.Read(key: string; value: String);
var
  P: TJsonPair;
  V: TJsonString;
begin
  V := TJsonString.Create(value);
  P := TJsonPair.Create(key, V);
  // self := P.ToJSON;
  self := '{' + P.ToString + '}';

  P.free;
  V := nil;
end;

procedure JsonAssistent.Read(value: TForm);

begin
  self := EmptyJson;
  with value do
  begin
    self.Read('Left', Left);
    self.Read('Top', Top);
    self.Read('Caption', Caption);
    self.Read('ClientHeight', ClientHeight);
    self.Read('ClientWidth', ClientWidth);
    self.Read('Color', Color);
    self.Read('Font.Charset', Font.Charset);
    self.Read('Font.Color', Font.Color);
    self.Read('Font.Height', Font.Height);
    self.Read('Font.Name', Font.Name);
    // self.read('Font.Style': [] enumeration ainda nao suportado
    self.Read('OldCreateOrder', OldCreateOrder);
    self.Read('PixelsPerInch', PixelsPerInch);
  end;

end;

procedure JsonAssistent.Read(value: TPanel);
begin
  self := EmptyJson;
  with value do
  begin
    self.Read('Left', Left);
    self.Read('Top', Top);
    self.Read('Caption', Caption);
    self.Read('Height', Height);
    self.Read('Width', Width);
    self.Read('Color', Color);
    self.Read('Font.Charset', Font.Charset);
    self.Read('Font.Color', Font.Color);
    self.Read('Font.Height', Font.Height);
    self.Read('Font.Name',Font.Name);
    // self.read('Font.Style': [] enumeration ainda nao suportado
  end;
end;

/// <summary>
/// Exporta apenas o registro atual. T�? Veja tutorial de como exportar Dataset inteiro
/// </summary>

/// Modelos
{ "codigo":1, "Nome": "TESLA CORP" }

{
  "campos": ["codigo", "nome"],
  "tipos": ["inteiro", "string"],
  "dados": {"codigo: 1, "Nome": "TESLA CORP" } // }

{
  "campos": {"codigo" : "inteiro", "nome": "string"] ,
  "dados" : [{"codigo": 1, "nome": "TESLA CORP" ... ]
}

procedure JsonAssistent.Read(Value: TDataset);
var
  CollumnName: String;
  CollumnValue: Variant;
  I: integer;

begin
  self := EmptyJson;

  with value do
  begin
    for I := 0 to value.Fields.Count - 1 do
    begin
      CollumnName := Value.Fields[I].FieldName;
      if Value.Fields[I].IsNull then
      begin
         self.Add(CollumnName, 'null');
         continue;
      end;

      CollumnValue := Value.Fields[I].Value;
      Case Value.Fields[i].Datatype of

        ftBoolean
          : self.Add(CollumnName, Value.Fields[I].AsBoolean);

        ftInteger,
         ftAutoinc,
         ftFloat,
         ftSmallint,
         ftWord,
         ftCurrency,
         ftExtended
          : self.Add(CollumnName, Value.Fields[I].AsExtended);

        ftDate,
         ftDatetime,
         ftTime
          : self.Add(CollumnName, formatdatetime('dd/mm/yyyy', CollumnValue));

      else
            self.Add(CollumnName, String(CollumnValue) );
      End;

    end;
  end;
end;

procedure JsonAssistent.Read(value: TChart);
begin

end;

procedure JsonAssistent.Read(value: String);
begin
  self.Read('valor', value);
end;

procedure JsonAssistent.ReadDate(key: String; value: TDate; Formato: String);
var
  P: TJsonPair;
  V: TJsonString;
begin
  V := TJsonString.Create(DateToISO8601(value));
  P := TJsonPair.Create(key, V);
  self := '{' + P.ToString + '}';
  P.free;
  V := nil;

end;

procedure JsonAssistent.ReadDate(key: String; value: TDateTime; Formato: String);
var
  P: TJsonPair;
  V: TJsonString;
begin
  V := TJsonString.Create(DateToISO8601(value));
  P := TJsonPair.Create(key, V);
  self := '{' + P.ToString + '}';
  P.free;
  V := nil;
end;

procedure JsonAssistent.ReadTime(key: String; value: TTime; Formato: String);
var
  P: TJsonPair;
  V: TJsonString;
begin
  V := TJsonString.Create(DateToISO8601(value));
  P := TJsonPair.Create(key, V);
  self := '{' + P.ToString + '}';
  P.free;
  V := nil;
end;

procedure JsonAssistent.SetKey(Index: string; const value: String);
var
  fInstance: TJsonObject;
  fReplace: String;
  JsonValue: Json;

begin

  JsonValue := EmptyJson;
  JsonValue.Read(value);
  JsonValue := JsonValue.Value['valor'];


  fInstance := JsonObjectInstance(self);
  fReplace := fInstance.Values[Index].ToString; // toJson
  if fReplace <> '' then
  begin
    if fInstance is TJsonValue then
    begin
      fReplace := Format('"%s"', [index]) + ':' + fReplace;
      JsonValue := Format('"%s"', [index]) + ':' + JsonValue;
      if JsonValue.asJsonValue <> nil then
        self := stringreplace(trim(self), fReplace, JsonValue.asJsonValue.ToString, [])
      else
        self := stringreplace(trim(self), fReplace, JsonValue, []);
    end;
  end
  else
  begin
    self.Add(Index, value);
  end;

end;

procedure JsonAssistent.StartArray;
begin
  self := '[';
end;

procedure JsonAssistent.template(value: string; const args: array of const);
begin
  self := Format(value, args)
end;

procedure JsonAssistent.Read(key: String; value: integer);
var
  P: TJsonPair;
  V: TJsonNumber;
begin
  V := TJsonNumber.Create(value);
  P := TJsonPair.Create(key, V);
  // self := P.ToJSON;
  self := '{' + P.ToString + '}';

  P.free;
  V := nil;
end;

procedure JsonAssistent.Read(key: String; value: int64);
var
  P: TJsonPair;
  V: TJsonNumber;
begin
  V := TJsonNumber.Create(value);
  P := TJsonPair.Create(key, V);
  // self := P.ToJSON;
  self := '{' + P.ToString + '}';

  P.free;
  V := nil;
end;

procedure JsonAssistent.Read(key: String; value: TStrings);
begin

  self := '{''erro'': ''TStrings ainda nao implementado''}'
end;

procedure JsonAssistent.Read(key: String; value: extended);
var
  P: TJsonPair;
  V: TJsonNumber;
begin
  V := TJsonNumber.Create(value);
  P := TJsonPair.Create(key, V);
  // self := P.ToJSON;
  self := '{' + P.ToString + '}';

  P.free;
  V := nil;
end;

procedure JsonAssistent.Read(key: String; value: TPanel);
begin

  self := '{''erro'': ''TPanel ainda nao implementado''}'
end;

procedure JsonAssistent.Read(key: String; value: TDataset);
begin
  self := '{''erro'': ''TDataset ainda nao implementado''}'
end;

procedure JsonAssistent.Read(key: String; value: TChart);
begin
  self := '{''erro'': ''TChart ainda nao implementado''}'
end;

procedure JsonAssistent.Read(key: String; value: boolean);
var
  P: TJsonPair;
var
  V: TJsonBool;
begin
  V := TJsonBool.Create(value);
  P := TJsonPair.Create(key, V);
  // self := P.ToJSON;
  self := '{' + P.ToString + '}';

  P.free;
  V := nil;
end;

procedure JsonAssistent.Read(key: String; value: TObject);
begin
end;

procedure JsonAssistent.Read(key: String; value: TForm);
begin
  self := '{''erro'': ''TForm ainda nao implementado''}'
end;

// procedure JsonAssistent.Read(Value: TValue);
// begin
//
// end;

procedure JsonAssistent.ReadTime(value: TTime; Formato: String);
begin
  self.ReadTime('hora', value, Formato);
end;

procedure JsonAssistent.Read(value: extended);
begin
  self.Read('valor', value);
end;

procedure JsonAssistent.Read(value: boolean);
begin
  self.Read('valor', value)
end;

procedure JsonAssistent.Read(var value: TObject);
begin
  self := TJson.ObjectToJsonString(value)
end;

// procedure JsonAssistent.Read(Value: TInterface);
// begin
//
// end;

{ TExemplo }

{ ListOfStringAssistent }

procedure ListOfStringAssistent.add(Value: String);
var
  NextItem: Integer;
begin
  NextItem := length(self);
  SetLength(self, NextItem +1);
  self[NextItem] := Value;

end;

procedure ListOfStringAssistent.clear;
begin
  setlength(self, 0);
end;

end.

/// // exemplo
  JSONColor := TJsonObject.Create; JSONColor.Add
('name', 'red'); JSONColor.Add
('hex', '#f00'); JSONArray := TJsonArray.Create; JSONArray.Add
(JSONColor); JSONObject := TJsonObject.Create; JSONObject.Add
('colors', JSONArray);
