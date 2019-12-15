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
	
	Конвейер = КонвейерЗаданийКлиент; 
	
	ДиалогВыбораПапки = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораПапки.МножественныйВыбор = Ложь;
	ДиалогВыбораПапки.Заголовок = НСтр("ru = 'Выберите каталог'; en = 'Select the folder'");
	
	// Ящик, который двигается по конвейеру через все этапы (см. ОбщиеПараметры в обработчиках заданий)
	ОбщиеПараметры = Новый Структура;
	ОбщиеПараметры.Вставить("ИмяПапки", Неопределено);
	ОбщиеПараметры.Вставить("ИмяПодпапки", Неопределено);
	
	СсылкаНаИмяПапки = Конвейер.Ссылка(ОбщиеПараметры, "ИмяПапки");
	СсылкаНаИмяПодпапки = Конвейер.Ссылка(ОбщиеПараметры, "ИмяПодпапки");
	
	// Обработчик ошибок, возникших на конвейере
	ОбработчикОшибок = Конвейер.ОбработчикОшибок("ОбработчикОшибок", ЭтотОбъект);
		
	// Формирование этапов конвейера и запуск
	
	Линия = Конвейер.СоздатьЛинию();
	
	#Область КонвейерВОбычномСтиле	
			
	Конвейер.ДиалогВыбораФайла(
		Линия,
		Новый ОписаниеОповещения("ОбработатьВыборПапки", ЭтотОбъект, ОбщиеПараметры),
		ДиалогВыбораПапки
	);
	
	Конвейер.Оператор_Если(Линия, "ПроверкаУсловия", ЭтотОбъект, ОбщиеПараметры);
		Конвейер.Оператор_Попытка(Линия);
			Конвейер.СозданиеКаталога(Линия, Неопределено, СсылкаНаИмяПапки);
			Конвейер.СозданиеКаталога(Линия, Неопределено, СсылкаНаИмяПодпапки, ОбработчикОшибок);
			Конвейер.УдалениеФайлов(Линия, Неопределено, СсылкаНаИмяПодпапки, Неопределено);
			Конвейер.ПроизвольноеЗадание(Линия, "ЗаданиеПриУспехе", ЭтотОбъект, Новый Структура("СсылкаНаИмяПапки", СсылкаНаИмяПапки));
		Конвейер.Оператор_Исключение(Линия);
			Конвейер.ПроизвольноеЗадание(Линия, "ЗаданиеОшибка", ЭтотОбъект, Неопределено);
			Конвейер.Оператор_Возврат(Линия);
		Конвейер.Оператор_КонецПопытки(Линия);
		Конвейер.ПроизвольноеЗадание(Линия, "ЗаданиеХвост1", ЭтотОбъект, Неопределено);
	Конвейер.Оператор_КонецЕсли(Линия);	
		
	Конвейер.ПроизвольноеЗадание(
		Линия,
		"ЗаданиеХвост2",
		ЭтотОбъект,
		Неопределено
	);
	
	Конвейер.НачатьВыполнение(
		Линия,
		ОбработчикОшибок,
		Неопределено,
		ОбщиеПараметры,
		"Обработка.Тест.Форма.ТестАсинхронный"
	);
	
	#КонецОбласти // КонвейерВОбычномСтиле
	
	// То же самое может быть записано иначе:
	
	#Если НЕ Клиент Тогда
		
		#Область КонвейерВТекучемСтиле
		
		Конвейер
		.ДиалогВыбораФайла(
			Линия,
			Новый ОписаниеОповещения("ОбработатьВыборПапки", ЭтотОбъект, ОбщиеПараметры),
			ДиалогВыбораПапки
		)
		.Оператор_Если(Линия, "ПроверкаУсловия", ЭтотОбъект, ОбщиеПараметры)
			.Оператор_Попытка(Линия)
				.СозданиеКаталога(Линия, Неопределено, СсылкаНаИмяПапки)
				.СозданиеКаталога(Линия, Неопределено, СсылкаНаИмяПодпапки, ОбработчикОшибок)
				.УдалениеФайлов(Линия, Неопределено, СсылкаНаИмяПодпапки, Неопределено)
				.ПроизвольноеЗадание(Линия, "ЗаданиеПриУспехе", ЭтотОбъект, Новый Структура("СсылкаНаИмяПапки", СсылкаНаИмяПапки))
			.Оператор_Исключение(Линия)
				.ПроизвольноеЗадание(Линия, "ЗаданиеОшибка", ЭтотОбъект, Неопределено)
				.Оператор_Возврат(Линия)
			.Оператор_КонецПопытки(Линия)
			.ПроизвольноеЗадание(Линия, "ЗаданиеХвост1", ЭтотОбъект, Неопределено)
		.Оператор_КонецЕсли(Линия)
		.ПроизвольноеЗадание(Линия, "ЗаданиеХвост2", ЭтотОбъект, Неопределено)
	 	.НачатьВыполнение(
			Линия,
			ОбработчикОшибок,
			Неопределено,
			ОбщиеПараметры,
			"Обработка.Тест.Форма.ТестАсинхронный"
		);
		
		#КонецОбласти // КонвейерВТекучемСтиле
	
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаУсловия(Результат, ОбщиеПараметры) Экспорт
	
	Результат = (ОбщиеПараметры.ИмяПапки <> Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборПапки(Результат, ОбщиеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;		
	КонецЕсли;
	
	ИмяПапки = Результат[0];
	
	ОбщиеПараметры.ИмяПапки = ИмяПапки;
	ОбщиеПараметры.ИмяПодпапки = ИмяПапки + "\_проверка_доступа_\";
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПриУспехе(ОбщиеПараметры, ПараметрыЗадания) Экспорт
	
	Сообщить(КонвейерЗаданийКлиент.ИзвлечьЗначение(ПараметрыЗадания.СсылкаНаИмяПапки));
	Сообщить("Успех");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеОшибка(ОбщиеПараметры, ПараметрыЗадания) Экспорт
	
	Сообщить("Ошибка");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеХвост1(ОбщиеПараметры, ПараметрыЗадания) Экспорт
	
	Сообщить("Хвост1");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеХвост2(ОбщиеПараметры, ПараметрыЗадания) Экспорт
	
	Сообщить("Хвост2");
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОшибок(КонтекстОшибки, ДополнительныеПараметры) Экспорт
	
	// нет прав скорее всего

	Сообщить(СтрШаблон("Ошибка: Текст = ""%1""; ИмяПапки = ""%2""", КраткоеПредставлениеОшибки(КонтекстОшибки.ИнформацияОбОшибке), КонтекстОшибки.ОбщиеПараметры.ИмяПапки));
		
КонецПроцедуры
