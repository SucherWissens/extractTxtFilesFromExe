program ManipulationCustomDataInExeFileConsole;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows, Classes, ManipulationTextFile;

const
   SIGNATURE_BUFFER_EXE_FILE = 'EB1.0';
   NAME_EXE_FILE = 'file/Notepad.exe';
   NAME_FIRST_TXT_FILE = 'file/first_text_file.txt';
   NAME_SECOND_TXT_FILE = 'file/second_text_file.txt';
type
  TFooterBufferExeFile = record
    originalSize : Integer;
    signature : array [0..4] of char;
  end;

  TBufferExeFile = array of char;


var
   {
   firstTestString : String;
   secondTestString : String;
   firstTestBuffer : TBufferExeFile;
   secondTestBuffer : TBufferExeFile;
   }
   {
   listLinesFile : TStringList;
   }
   counter : Integer;
   arrayStrings : TStringArray;
   singleString : TCharacterArray;

function getAnsiStringFromString(const ansiString: string): string;
begin
  SetLength(Result, Length(ansiString));
  if Length(Result) > 0 then
    CharToOem(PChar(ansiString), PChar(Result));
end;

procedure setDataInExeFile (nameExeFile : String; bufferExeFile : TBufferExeFile);
var
  fileHandler : File;
  bufferSize: Integer;
  originalSize : Integer;
  footerBufferExeFile : TFooterBufferExeFile;
begin
  AssignFile(fileHandler, nameExeFile);
  Reset(fileHandler, 1);
  try
    originalSize := FileSize(fileHandler);

    {
      ������� � ����� �����
    }
    Seek(fileHandler, originalSize);
    bufferSize := Length(bufferExeFile);

    {
      ������ ���������������� ������ � ������� ����
      ������������� ������� �����
    }
    BlockWrite(fileHandler, Pointer(bufferExeFile)^, bufferSize);

    {
      ��������� �����
    }
    FillChar(footerBufferExeFile, SizeOf(footerBufferExeFile), 0);
    footerBufferExeFile.originalSize := originalSize;
    footerBufferExeFile.signature := SIGNATURE_BUFFER_EXE_FILE;

    BlockWrite(fileHandler, footerBufferExeFile, Sizeof(footerBufferExeFile));
  finally
    CloseFile(fileHandler);
  end;
end;

function getDataFromExeFile(nameExeFile : String) : TBufferExeFile;
var
  fileHandler : File;
  originalFileSize : Integer;
  bufferSize : Integer;
  oldFileMode : Integer;
  footerBufferExeFile : TFooterBufferExeFile;
  bufferExeFile : TBufferExeFile;
begin
  AssignFile(fileHandler, nameExeFile);

  oldFileMode := FileMode;

  {
    ����� ������ � ������ ����������
    ������ ��� ������
  }
  FileMode := 0;

  try
    Reset(fileHandler, 1);
    try
      originalFileSize := FileSize(fileHandler);

      {
        ��������� � ������� ������
        � ��������� �����
      }
      Seek(fileHandler, originalFileSize - SizeOf(footerBufferExeFile));
      BlockRead(fileHandler, footerBufferExeFile, Sizeof(footerBufferExeFile));

      {
         ���� ��������� *.exe ����� �� ���������,
         ������ ��� �������������� ����������������
         ������
      }
      if footerBufferExeFile.signature <> SIGNATURE_BUFFER_EXE_FILE then
          Writeln(getAnsiStringFromString('����������� ���� �� ����� �������������� ����������������� ������!'));
      {
          ���������� ������ ������ ������� ��� �������
          � ����������� ����
      }
      bufferSize := originalFileSize - footerBufferExeFile.originalSize - SizeOf(footerBufferExeFile);
      SetLength (bufferExeFile, bufferSize);

      {
          ��������� � ������������ ������� ������
      }
      Seek (fileHandler, footerBufferExeFile.originalSize);
      BlockRead(fileHandler, Pointer(bufferExeFile)^, bufferSize);
    finally
      CloseFile(fileHandler);
    end;
  finally

    {
        ��������� ���� � ���������� ����� ������
    }
    FileMode := oldFileMode;

  end;

  Result := bufferExeFile;
end;

function getBufferExeFileFromString (const stringData : String) : TBufferExeFile;
var
  bufferExeFile : TBufferExeFile;
begin
  SetLength(bufferExeFile, Length(stringData)*SizeOf(Char));
  Move(Pointer(stringData)^, Pointer(bufferExeFile)^, Length(stringData) * SizeOf(Char));

  Result := bufferExeFile; 
end;



function getStringFromBufferExeFile(const bufferExeFile : TBufferExeFile) : String;
var
  stringData : String;
begin
  SetLength (stringData, Length(bufferExeFile) div SizeOf(Char));
  Move(Pointer(bufferExeFile)^, Pointer(stringData)^, Length(stringData)* SizeOf(Char));

  Result := stringData;
end;

begin
    Writeln(getAnsiStringFromString('��� ��������� ��������!'));

    {*
     * ������ � ���������� ������ ������ � *.exe �����
     *}

     {
     firstTestString :='Ich liebe meinen Vaterland!!!';
     Writeln(getAnsiStringFromString('������ �� ������ � *.exe ����: ') + getAnsiStringFromString(firstTestString));

     firstTestBuffer := getBufferExeFileFromString(firstTestString);
     setDataInExeFile(NAME_EXE_FILE, firstTestBuffer);
     secondTestBuffer := getDataFromExeFile(NAME_EXE_FILE);

     secondTestString := getStringFromBufferExeFile(secondTestBuffer);
     Writeln(getAnsiStringFromString('������ ��������� � ������ *.exe �����: ') + getAnsiStringFromString(secondTestString));

     Readln;
     }

     {*
      * ������ ����� ����� ������
      *}
      {
      Writeln(getAnsiStringFromString('������ ������� �����: '));
      printLinesFromFile(NAME_FIRST_TXT_FILE);

      Writeln;
      Writeln(getAnsiStringFromString('������ ������� �����: '));
      printLinesFromFile(NAME_SECOND_TXT_FILE);

      Readln;
      }

     {*
      * ������ ������ ����� ������ ��������� � ������ �����
      *}
      {
      Writeln(getAnsiStringFromString('������ ������� �����: '));

      arrayStrings := readLinesFromFile(NAME_SECOND_TXT_FILE);

      for counter := 0 to Length(arrayStrings)-1 do
      begin
           Writeln(getAnsiStringFromString('������ ������ �����: ') + IntToStr(Length(arrayStrings[counter])));
           Writeln(getAnsiStringFromString('������: ') + getAnsiStringFromString(arrayStrings[counter]));
      end;

      Readln;
      }

      {*
       * ������ ������ ����� ������ ��� ������ �����
       *}
       {
       Writeln(getAnsiStringFromString('������ ������� ����� ��� ������ �����: '));

       arrayStrings := getLinesFileWithoutEmptyLines(readLinesFromFile(NAME_SECOND_TXT_FILE));

       for counter := 0 to Length(arrayStrings)-1 do
       begin
            Writeln(getAnsiStringFromString('������: ') + getAnsiStringFromString(arrayStrings[counter]));
       end;

       Readln;
       }

       Readln;
end.
