﻿
// Copyright 2020 Tsukanov Alexander. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

Функция СоздатьСценарий(Модуль, Отладка = Ложь) Экспорт
	
	Сценарий = Новый Структура;
	Сценарий.Вставить("Задания", Новый Массив);
	Сценарий.Вставить("ОбработчикПервогоЗадания", Неопределено);
	Сценарий.Вставить("Модуль", Модуль);
	Если Отладка Тогда
		Сценарий.Вставить("Форма", ПолучитьФорму("ОбщаяФорма.КонвейерЗаданий"));
	Иначе
		Сценарий.Вставить("Форма", Неопределено);
	КонецЕсли; 
	
	Возврат Сценарий;
	
КонецФункции 

Процедура НачатьВыполнение(Сценарий, Переменные, ОбработчикОшибок, СледующийОбработчикЗадания = Неопределено) Экспорт
	
	КонвейерЗаданийСлужебныйКлиент.ПодготовитьСценарий(
		Сценарий,
		ОбработчикОшибок,
		СледующийОбработчикЗадания
	);
	
	Если Сценарий.Форма <> Неопределено
		И Не Сценарий.Форма.Открыта() Тогда
		Сценарий.Форма.Открыть();
	КонецЕсли; 
	
	КонвейерЗаданийСлужебныйКлиент.Вызвать(
		Сценарий.ОбработчикПервогоЗадания,
		Переменные
	);
	
КонецПроцедуры

#Область Задания

// TODO: прописать каждому заданию какие параметры могут быть ссылками

// Произвольное задание. По окончании управление сразу передается на следующий этап в конвейере.
// ИмяПроцедуры - имя процедуры, которая должна быть экспортной, на клиенте, и иметь два параметра: КонтекстЗадания, ДополнительныеПараметры
// Модуль - модуль, в котором находится процедура
// ДополнительныеПараметры - произвольный параметр, который передается этапу в ДополнительныеПараметры
Функция ПроизвольноеЗадание(Сценарий, ИмяПроцедуры, ДополнительныеПараметры = Неопределено) Экспорт
	
	Обработчик = Новый ОписаниеОповещения(
		ИмяПроцедуры,
		Сценарий.Модуль,
		ДополнительныеПараметры
	);
	
	ДекорированныйОбработчик = КонвейерЗаданийСлужебныйКлиент.ДекорироватьОбработчик(Обработчик);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ДекорированныйОбработчик", ДекорированныйОбработчик);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьПроизвольноеЗадание = Новый ОписаниеОповещения(
		"_ВыполнитьПроизвольноеЗадание",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);	
	
	Сценарий.Задания.Добавить(_ВыполнитьПроизвольноеЗадание);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ДиалогВыбораФайла(Сценарий, Обработчик, ДиалогВыбораФайла, ОбработчикОшибок = Неопределено) Экспорт
	
	ДекорированныйОбработчик = КонвейерЗаданийСлужебныйКлиент.ДекорироватьОбработчик(Обработчик);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ДекорированныйОбработчик", ДекорированныйОбработчик);
	ПараметрыЗадания.Вставить("ДиалогВыбораФайла", ДиалогВыбораФайла);
	ПараметрыЗадания.Вставить("ОбработчикОшибок", ОбработчикОшибок);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьЗаданиеДиалогВыбораФайла = Новый ОписаниеОповещения(
		"_ВыполнитьЗаданиеДиалогВыбораФайла",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьЗаданиеДиалогВыбораФайла);
	
	Возврат ЭтотОбъект;
	
КонецФункции 

Функция СозданиеКаталога(Сценарий, Обработчик, ИмяКаталога, ОбработчикОшибок = Неопределено) Экспорт
	
	ДекорированныйОбработчик = КонвейерЗаданийСлужебныйКлиент.ДекорироватьОбработчик(Обработчик);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ДекорированныйОбработчик", ДекорированныйОбработчик);
	ПараметрыЗадания.Вставить("ИмяКаталога", ИмяКаталога);
	ПараметрыЗадания.Вставить("ОбработчикОшибок", ОбработчикОшибок);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьЗаданиеСозданиеКаталога = Новый ОписаниеОповещения(
		"_ВыполнитьЗаданиеСозданиеКаталога",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьЗаданиеСозданиеКаталога);
	
	Возврат ЭтотОбъект;
	
КонецФункции 

Функция УдалениеФайлов(Сценарий, Обработчик, Путь, Маска = Неопределено, ОбработчикОшибок = Неопределено) Экспорт
	
	ДекорированныйОбработчик = КонвейерЗаданийСлужебныйКлиент.ДекорироватьОбработчик(Обработчик, "_ВыполнитьОбработчик1");
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ДекорированныйОбработчик", ДекорированныйОбработчик);
	ПараметрыЗадания.Вставить("Путь", Путь);
	ПараметрыЗадания.Вставить("Маска", Маска);
	ПараметрыЗадания.Вставить("ОбработчикОшибок", ОбработчикОшибок);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьЗаданиеУдалениеФайлов = Новый ОписаниеОповещения(
		"_ВыполнитьЗаданиеУдалениеФайлов",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьЗаданиеУдалениеФайлов);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ДиалогВопроса(Сценарий, Обработчик, ТекстВопроса, Кнопки, Таймаут = 0, КнопкаПоУмолчанию = Неопределено, Заголовок = Неопределено, КнопкаТаймаута = Неопределено) Экспорт
	
	ДекорированныйОбработчик = КонвейерЗаданийСлужебныйКлиент.ДекорироватьОбработчик(Обработчик);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ДекорированныйОбработчик", ДекорированныйОбработчик);
	ПараметрыЗадания.Вставить("ТекстВопроса", ТекстВопроса);
	ПараметрыЗадания.Вставить("Кнопки", Кнопки);
	ПараметрыЗадания.Вставить("Таймаут", Таймаут);
	ПараметрыЗадания.Вставить("КнопкаПоУмолчанию", КнопкаПоУмолчанию);
	ПараметрыЗадания.Вставить("Заголовок", Заголовок);
	ПараметрыЗадания.Вставить("КнопкаТаймаута", КнопкаТаймаута);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьЗаданиеДиалогВопроса = Новый ОписаниеОповещения(
		"_ВыполнитьЗаданиеДиалогВопроса",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьЗаданиеДиалогВопроса);
	
	Возврат ЭтотОбъект;
	
КонецФункции

#КонецОбласти // Задания

#Область Операторы

Функция ОператорЕсли(Сценарий, ИмяПроцедуры, ДополнительныеПараметры = Неопределено) Экспорт
	
	// без декоратора
	Обработчик = Новый ОписаниеОповещения(
		ИмяПроцедуры,
		Сценарий.Модуль,
		ДополнительныеПараметры
	);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Обработчик", Обработчик);
	ПараметрыЗадания.Вставить("ОбработчикЗаданияЕслиЛожь", Неопределено);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорЕсли = Новый ОписаниеОповещения(
		"_ВыполнитьОператорЕсли",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
		
	Сценарий.Задания.Добавить(_ВыполнитьОператорЕсли);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ОператорИначеЕсли(Сценарий, ИмяПроцедуры, ДополнительныеПараметры = Неопределено) Экспорт
	
	// без декоратора
	Обработчик = Новый ОписаниеОповещения(
		ИмяПроцедуры,
		Сценарий.Модуль,
		ДополнительныеПараметры
	);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Обработчик", Обработчик);
	ПараметрыЗадания.Вставить("ОбработчикЗаданияЕслиЛожь", Неопределено);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорИначеЕсли = Новый ОписаниеОповещения(
		"_ВыполнитьОператорИначеЕсли",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
		
	Сценарий.Задания.Добавить(_ВыполнитьОператорИначеЕсли);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ОператорИначе(Сценарий) Экспорт
	
	ПараметрыЗадания = Новый Структура;
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорИначе = Новый ОписаниеОповещения(
		"_ВыполнитьОператорИначе",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьОператорИначе);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ОператорКонецЕсли(Сценарий) Экспорт
	
	ПараметрыЗадания = Новый Структура;
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорКонецЕсли = Новый ОписаниеОповещения(
		"_ВыполнитьОператорКонецЕсли",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьОператорКонецЕсли);
	
	Возврат ЭтотОбъект;
	
КонецФункции 

Функция ОператорПопытка(Сценарий) Экспорт
	
	ПараметрыЗадания = Новый Структура;
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорПопытка = Новый ОписаниеОповещения(
		"_ВыполнитьОператорПопытка",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьОператорПопытка);
	
	Возврат ЭтотОбъект;
	
КонецФункции 

Функция ОператорИсключение(Сценарий) Экспорт
	
	ПараметрыЗадания = Новый Структура;
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорИсключение = Новый ОписаниеОповещения(
		"_ВыполнитьОператорИсключение",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьОператорИсключение);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ОператорКонецПопытки(Сценарий) Экспорт
	
	ПараметрыЗадания = Новый Структура;
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорКонецПопытки = Новый ОписаниеОповещения(
		"_ВыполнитьОператорКонецПопытки",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьОператорКонецПопытки);
	
	Возврат ЭтотОбъект;
	
КонецФункции 

Функция ОператорВозврат(Сценарий) Экспорт
		
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("СледующийОбработчикЗадания", Неопределено);
	
	ДополнитьПараметрыЗадания(ПараметрыЗадания);
	
	_ВыполнитьОператорВозврат = Новый ОписаниеОповещения(
		"_ВыполнитьОператорВозврат",
		КонвейерЗаданийСлужебныйКлиент,
		ПараметрыЗадания
	);
	
	Сценарий.Задания.Добавить(_ВыполнитьОператорВозврат);
	
	Возврат ЭтотОбъект;
	
КонецФункции

#КонецОбласти // Операторы

#Область СинонимыОператоров

Функция Оператор_Если(Сценарий, ИмяПроцедуры, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ОператорЕсли(Сценарий, ИмяПроцедуры, ДополнительныеПараметры);
	
КонецФункции

Функция Оператор_ИначеЕсли(Сценарий, ИмяПроцедуры, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ОператорИначеЕсли(Сценарий, ИмяПроцедуры, ДополнительныеПараметры);
	
КонецФункции

Функция Оператор_Иначе(Сценарий) Экспорт
	
	Возврат ОператорИначе(Сценарий);
	
КонецФункции 

Функция Оператор_КонецЕсли(Сценарий) Экспорт
	
	Возврат ОператорКонецЕсли(Сценарий);
	
КонецФункции

Функция Оператор_Попытка(Сценарий) Экспорт
	
	Возврат ОператорПопытка(Сценарий);
	
КонецФункции 

Функция Оператор_Исключение(Сценарий) Экспорт
		
	Возврат ОператорИсключение(Сценарий);
	
КонецФункции

Функция Оператор_КонецПопытки(Сценарий) Экспорт
	
	Возврат ОператорКонецПопытки(Сценарий);
	
КонецФункции 

Функция Оператор_Возврат(Сценарий) Экспорт
	
	Возврат ОператорВозврат(Сценарий);
	
КонецФункции

#КонецОбласти // СинонимыОператоров

#Область СлужебныеМетоды

// Создает новый обработчик ошибок
Функция ОбработчикОшибок(ИмяПроцедуры, Модуль) Экспорт
	
	// TODO: может лучше декорировать?
	
	Возврат Новый ОписаниеОповещения(ИмяПроцедуры, Модуль, Новый Структура);
	
КонецФункции

Функция ИзвлечьЗначение(Значение) Экспорт
	
	Возврат КонвейерЗаданийСлужебныйКлиент.ИзвлечьЗначение(Значение); 
	
КонецФункции 

Функция Ссылка(Коллекция, Ключ) Экспорт
	
	Возврат КонвейерЗаданийСлужебныйКлиент.Ссылка(Коллекция, Ключ);
	
КонецФункции 

Функция ДополнитьПараметрыЗадания(ПараметрыЗадания)
	
	ДобавитьСвойствоЕслиОтсутствует(ПараметрыЗадания, "ОбработчикОшибок");
	ДобавитьСвойствоЕслиОтсутствует(ПараметрыЗадания, "ОбработчикЗаданияОператорИсключение");
	
КонецФункции 

Процедура ДобавитьСвойствоЕслиОтсутствует(Структура, ИмяСвойства)
	
	Если Не Структура.Свойство(ИмяСвойства) Тогда
		Структура.Вставить(ИмяСвойства);
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти // СлужебныеМетоды
