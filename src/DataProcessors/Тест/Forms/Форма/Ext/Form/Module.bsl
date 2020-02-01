﻿
&НаКлиенте
Процедура ТестСинхронный(Command)
	
	ОчиститьСообщения();
	
	ДиалогВыбораПапки = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораПапки.МножественныйВыбор = Ложь;
	ДиалогВыбораПапки.Заголовок = НСтр("ru = 'Выберите каталог'; en = 'Select the folder'");
	
	Если ДиалогВыбораПапки.Выбрать() Тогда
		
		ИмяПапки = ДиалогВыбораПапки.Каталог;
				
		Попытка
			
			СоздатьКаталог(ИмяПапки);
			СоздатьКаталог(ИмяПапки + "\_проверка_доступа_\");
			УдалитьФайлы(ИмяПапки + "\_проверка_доступа_\");
			
			Сообщить(ИмяПапки);
			Сообщить("Успех");
			
		Исключение
			
			// нет прав скорее всего
			
			Сообщить("Ошибка");
			
			Возврат;
			
		КонецПопытки;
		
		Сообщить("Хвост1");
		
	КонецЕсли;
	
	Сообщить("Хвост2");
	
КонецПроцедуры

&НаКлиенте
Процедура ТестАсинхронный(Команда)
	
	ОчиститьСообщения();
	
	Коза = КонвейерЗаданийКлиент; 
	
	ДиалогВыбораПапки = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораПапки.МножественныйВыбор = Ложь;
	ДиалогВыбораПапки.Заголовок = НСтр("ru = 'Выберите каталог'; en = 'Select the folder'");
	
	// см. параметр "Переменные" в обработчиках заданий
	Переменные = Новый Структура;
	Переменные.Вставить("ИмяПапки", Неопределено);
	Переменные.Вставить("ИмяПодпапки", Неопределено);
	
	СсылкаНаИмяПапки = Коза.Ссылка(Переменные, "ИмяПапки");
	СсылкаНаИмяПодпапки = Коза.Ссылка(Переменные, "ИмяПодпапки");
	
	// Обработчик ошибок, возникших на конвейере
	ОбработчикОшибок = Коза.ОбработчикОшибок("ОбработчикОшибок", ЭтотОбъект);
		
	// Формирование этапов конвейера и запуск
	
	Сценарий = Коза.СоздатьСценарий(ЭтотОбъект);
	
	#Область Коза	
	
	Коза.ДиалогВыбораФайла(Сценарий, Обработчик("ОбработатьВыборПапки", Переменные), ДиалогВыбораПапки);
	Коза.Оператор_Если(Сценарий, "ПроверкаУсловия");
		Коза.Оператор_Попытка(Сценарий);
			Коза.СозданиеКаталога(Сценарий, Неопределено, СсылкаНаИмяПапки);
			Коза.СозданиеКаталога(Сценарий, Неопределено, СсылкаНаИмяПодпапки, ОбработчикОшибок);
			Коза.УдалениеФайлов(Сценарий, Неопределено, СсылкаНаИмяПодпапки);
			Коза.ПроизвольноеЗадание(Сценарий, "ЗаданиеПриУспехе", Новый Структура("СсылкаНаИмяПапки", СсылкаНаИмяПапки));
		Коза.Оператор_Исключение(Сценарий);
			Коза.ПроизвольноеЗадание(Сценарий, "ЗаданиеОшибка");
			Коза.Оператор_Возврат(Сценарий);
		Коза.Оператор_КонецПопытки(Сценарий);
		Коза.ПроизвольноеЗадание(Сценарий, "ЗаданиеХвост1");
	Коза.Оператор_КонецЕсли(Сценарий);		
	Коза.ПроизвольноеЗадание(Сценарий, "ЗаданиеХвост2");
	Коза.НачатьВыполнение(Сценарий, Переменные, ОбработчикОшибок);
	
	#КонецОбласти // Конвейер
		
КонецПроцедуры

&НаКлиенте
Функция Обработчик(ИмяПроцедуры, ПараметрыОбработчика)
	Возврат Новый ОписаниеОповещения(ИмяПроцедуры, ЭтотОбъект, ПараметрыОбработчика)
КонецФункции 	
	
&НаКлиенте
Функция ПроверкаУсловия(Переменные, ДополнительныеПараметры) Экспорт
	
	Возврат Переменные.ИмяПапки <> Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборПапки(Результат, Переменные) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;		
	КонецЕсли;
	
	ИмяПапки = Результат[0];
	
	Переменные.ИмяПапки = ИмяПапки;
	Переменные.ИмяПодпапки = ИмяПапки + "\_проверка_доступа_\";
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПриУспехе(Переменные, ПараметрыЗадания) Экспорт
	
	Сообщить(КонвейерЗаданийКлиент.ИзвлечьЗначение(ПараметрыЗадания.СсылкаНаИмяПапки));
	Сообщить("Успех");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеОшибка(Переменные, ПараметрыЗадания) Экспорт
	
	Сообщить("Ошибка");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеХвост1(Переменные, ПараметрыЗадания) Экспорт
	
	Сообщить("Хвост1");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеХвост2(Переменные, ПараметрыЗадания) Экспорт
	
	Сообщить("Хвост2");
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОшибок(КонтекстОшибки, ДополнительныеПараметры) Экспорт
	
	// нет прав скорее всего

	Сообщить(СтрШаблон("Ошибка: Текст = ""%1""; ИмяПапки = ""%2""", КраткоеПредставлениеОшибки(КонтекстОшибки.ИнформацияОбОшибке), КонтекстОшибки.Переменные.ИмяПапки));
		
КонецПроцедуры
