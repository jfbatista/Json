# Json
A single json type based on native string type for Delphi

# Easy
To use the Json type just add the unit assis.json; Then declare a variable of type json, same as a string variable.

```  Delphi
uses assis.json;
var Employee: Json;
    Id: integer;
    Name: String;
    Loc: String;
begin
  Employee := '{"id": 965, "name": "Jose", "location": "Brasil"} 
  Id := Employee.value['id'];
  Name := Employee.value['name'];
  Loc := Employee.value['location'];
end;
```
 
# Powerfull
Json type is made by putting adittional funcionalities into the native String, using record helper
You can extend the Json Power as you want.

Require recent version of Delphi
Recommended Delphi CE.
![Screen shot of Json Prototype Demo](https://github.com/ricardodarocha/Json/blob/master/ProtoJson.PNG)
