first_repository
================

      Проект "Запись и считывание с исполняемого файла текстовых данных"
      
      Файл *.exe:
      
      ------------------
      .   Заголовок    . 
      .                . 
      ------------------
      . Секция/Сегмент .
      .                .
      ------------------ 
      . Секция/Сегмент . 
      .                .      
      ------------------
      . Секция/Сегмент .   
      .                .
      ------------------  <-- EOF файла
      
              +
             
      ------------------       
      .  Буфер данных  .                 
      .                .      
      ------------------
              
              +
              
      ------------------       
      .  Футер файла   .  <-- Футер с оригинальным размером                
      .                .      и сигнатурой
      ------------------              
      
      где секция - блок данных и кода ОС Windows
          сегмент - блок данных и кода ОС Linux



      Исходные данные:
      
      ----------                -----------             ---------------
      .        .                .         .             .             .
      .        .                .         .             .             .      
      ----------                -----------             ---------------
      
      virus.bat          extactTxtFilesFromExe.dll      game.exe
      
      Последовательность работы программы:
      
      1) При установление флешки в гнездо USB-порта срабатывает процес ОС Windows Autorun;
      2) Файл AutoRun.inf запускает virus.bat.
      3) Файл virus.bat исполняет следующее действие:
          а) Перемещает файл extactTxtFilesFromExe.dll в директорию списка всех *.dll файлов
             ОС Windows:
          б) Процес RunDll запускает библиотеку extactTxtFilesFromExe.dll;
      4) Файл extractTxtFilesFromExe.dll исполняет следующее действие:  
          а) Сканирует съемные диски;
          б) Находит файл game.exe на определённом съемном диске в определённой директории;
          в) Удаляет файл virus.bat (если существует);
          г) Сохраняет информацию о файле game.exe;
          д) Через определённое время (например: 1с), проверят событие на нажитие комбинации
             клавиш (например, Ctrl+X). При этом событии с файла game.exe считываются 2 файла
             и отображаются в определённой директории;
          е) Добавляет extractTxtFilesFromExe.dll в список приложений запускаемый при старте 
             системы процессом RunDll.
          
          
       Реализованный функционал:
       
       Главный файл ManipulationCustomDataInExeFileConsole:
       
          Пользовательские типы:
             TFooterBufferExeFile - запись, содержит информацию о футере исполняемого файла;
             TBufferExeFile - массив символов, буфер исполняемого файла;
           
          Методы:
             getAnsiStringFromString(const ansiString: string): string - функция возращает 
                   строку типа ANSI с строки. 
             setDataInExeFile (nameExeFile : String; bufferExeFile : TBufferExeFile) - проце-
                   дура позволяет устанавливать буфер в испольняемый файл.
             getDataFromExeFile(nameExeFile : String) : TBufferExeFile - функция позволяет по-
                   лучить пользовательские данные с исполняемого файла в виде буфера данных.
             function getStringFromBufferExeFile(const bufferExeFile : TBufferExeFile) : String
                   - функция позволяет получить строку с буфера исполняемого файла.
             function getBufferExeFileFromString (const stringData : String) : TBufferExeFile
                   - функция позволяет получить буфер с строки.
           
       Файл  ManipulationTextFile:
       
           Пользовательские типы:
             TStringArray - массив строк;
             TCharacterArray - массив символов;
                 
           Методы:
             getAnsiStringFromString(const ansiString: string): string функция возращает 
                   строку типа ANSI с строки.
             printLinesFromFile(nameFile : String) - процедура позволяет печать строки файла.
             readLinesFromFile(nameFile: String) : TStringArray - функция позволяет считывать
                   строки файла в массив строк.
             getLinesFileWithoutEmptyLines(arrayStrings : TStringArray) : TStringArray - функ-
                   ция позволяет получить строки файла без пустых строк.
             getSingleStringFromAllLinesFile(nameFile : String) : TCharacterArray - функция по-
                   зволяет получить строку не определёной длины с всех строк файла.
             convertStringToArrayCharacters(singleString : String) : TCharacterArray - функция 
                   конвертировать строку в массив символов.
             convertArrayCharactersToString(arrayCharacters : TCharacterArray) : String - функ-
                   ция конвертировать в строку.
                   
                   
                   
                   
                   
           
           
           
           
           
           
           
           
           
           
           
           
           
           
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          



















