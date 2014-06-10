unit ManipulationTextFile;

interface
    uses SysUtils, Windows, Classes;

    type
        TStringArray = array of string;
        TCharacterArray = array of char;

    function getAnsiStringFromString(const ansiString: string): string;
    procedure printLinesFromFile(nameFile : String);
    function readLinesFromFile(nameFile: String) : TStringArray;
    function getLinesFileWithoutEmptyLines(arrayStrings : TStringArray) : TStringArray;
    function getSingleStringFromAllLinesFile(nameFile : String) : TCharacterArray;
    function convertStringToArrayCharacters(singleString : String) : TCharacterArray;
    function convertArrayCharactersToString(arrayCharacters : TCharacterArray) : String;

implementation

    function getAnsiStringFromString(const ansiString: string): string;
    begin
        SetLength(Result, Length(ansiString));
        if Length(Result) > 0 then
          CharToOem(PChar(ansiString), PChar(Result));
    end;

    procedure printLinesFromFile(nameFile : String);
    var
        fileHandler : TextFile;
        lineFile : String;
    begin
         Writeln(getAnsiStringFromString('Чтение строк с файла:  ' + nameFile));
         AssignFile(fileHandler, nameFile);

         {$I+}

         try
             Reset(fileHandler);

             repeat
                Readln(fileHandler, lineFile);
                Writeln(getAnsiStringFromString(lineFile));
             until(Eof(fileHandler));
             CloseFile(fileHandler);
         except
             on e : EInOutError do
             begin
                 Writeln(getAnsiStringFromString('Ошибка при работе с файлом была найдена. Детали: ') + e.ClassName + '/' + e.Message);
             end;
         end;
    end;

    function readLinesFromFile(nameFile: String) : TStringArray;
    var
        listLinesFile : TStringlist;
        arrayStrings : TStringArray;
        counter : Integer;
    begin
      listLinesFile := TStringList.Create;

      try
          listLinesFile.LoadFromFile(nameFile);
          SetLength(arrayStrings, listLinesFile.Count);

          for counter := 0 to listLinesFile.Count-1 do
          begin
              arrayStrings[counter] := listLinesFile[counter];
          end;

      finally
          listLinesFile.Free;
      end;

          Result := arrayStrings;
    end;

    function getLinesFileWithoutEmptyLines(arrayStrings : TStringArray) : TStringArray;
    var
        listLinesFile : TStringlist;
        arrayStringsWithoutEmptyStrings : TStringArray;
        counter : Integer;
    begin
      listLinesFile := TStringList.Create;

      try
          for counter := 0 to Length(arrayStrings) - 1 do
          begin
              if (Length(arrayStrings[counter]) <> 0) and (Length(arrayStrings[counter]) <> 2) then
              begin
                   listLinesFile.Add(arrayStrings[counter]);
              end;
          end;

          SetLength(arrayStringsWithoutEmptyStrings, listLinesFile.Count);
          for counter := 0 to listLinesFile.Count - 1 do
          begin
               arrayStringsWithoutEmptyStrings[counter] := listLinesFile[counter];
          end;

      finally
          listLinesFile.Free;
      end;

          Result := arrayStringsWithoutEmptyStrings;
    end;

    function convertStringToArrayCharacters(singleString : String) : TCharacterArray;
    var
        arrayCharacters: TCharacterArray;
        counter : Integer;
    begin
        SetLength(arrayCharacters, Length(singleString));

        for counter := 1 to Length(singleString) do
        begin
             arrayCharacters[counter - 1] := singleString[counter];
        end;

        Result := arrayCharacters;
    end;


    function convertArrayCharactersToString(arrayCharacters : TCharacterArray) : String;
    var
        singleString : String;
        counter : Integer;
    begin
         SetLength(singleString, Length(arrayCharacters));

         for counter := 0 to Length(arrayCharacters)-1 do
         begin
              singleString[counter + 1] := arrayCharacters[counter - 1];
         end;

         Result := singleString;
    end;


    function getSingleStringFromAllLinesFile(nameFile : String) : TCharacterArray;
    var
        listLinesFile : TStringList;
        singleString : TCharacterArray;
        counter : Integer;
    begin
          listLinesFile := TStringList.Create;

          try
             listLinesFile.LoadFromFile(nameFile);
             singleString := convertStringToArrayCharacters(listLinesFile.Text);
          finally
              listLinesFile.Free;
          end;

          Result := singleString;
    end;

    {
    function getAllLineFilesFromSingleString(arrayCharacters : TCharacterArray) : TStringArray;
    var
        singleString : String;
        listLinesFile : TStringList;
        arrayStrings : TStringArray;
        counter : Integer;
    begin
        listLinesFile := TStringList.Create;

        try
             singleString := convertArrayCharactersToString(arrayCharacters);
             listLinesFile.Delimiter := '#13#10';
             listLinesFile.DelimitedText := singleString;

             SetLength(arrayStrings, listLinesFile.Count);

             for counter := 0 to listLinesFile.Count-1 do
             begin
                 arrayStrings[counter] := listLinesFile[counter];
             end;
        finally
            listLinesFile.Free;
        end;

          Result := arrayStrings;
    end;
    }



end.
