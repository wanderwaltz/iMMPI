import Foundation

enum Strings {
    static let newRecord = NSLocalizedString("Новая запись", comment: "Заголовок экрана создания записи")
    static let editRecord = NSLocalizedString("Редактировать запись", comment: "Заголовок экрана редактирования записи")
    static let selectDate = NSLocalizedString("Выберите дату", comment: "Заголовок экрана выбора даты")
    static let trash = NSLocalizedString("Корзина", comment: "Заголовок экрана корзины")

    static let records = NSLocalizedString("Записи", comment: "Кнопка перехода ко всем записям")
    static let answers = NSLocalizedString("Ответы", comment: "Кнопка перехода на экран ответов")

    static let delete = NSLocalizedString("Удалить", comment: "Кнопка удаления")

    static let formPersonName = NSLocalizedString("ФИО", comment: "Поле 'ФИО' формы редактирования записи")

    static let formPersonNamePlaceholder =
        NSLocalizedString("Иванов Иван Иванович",
                          comment: "Плейсхолдер поля 'ФИО' формы редактирования записи")

    static let formGender = NSLocalizedString("Пол", comment: "Поле 'Пол' формы редактирования записи")

    static let formAgeGroup =
        NSLocalizedString("Возрастная группа", comment: "Поле 'Возрастная группа' формы редактирования записи")

    static let formDate =
        NSLocalizedString("Дата тестирования", comment: "Поле 'Дата тестирования' формы редактирования записи")

    static let filterResults = NSLocalizedString("Фильтр значений", comment: "Опция анализа")
    static let hideNormalResults = NSLocalizedString("Скрыть норму", comment: "Опция анализа")

    static let ageGroupAdult = NSLocalizedString("Взрослая", comment: "Название возрастной группы")
    static let ageGroupTeen = NSLocalizedString("Подростковая", comment: "Название возрастной группы")

    static let genderMale = NSLocalizedString("Мужской", comment: "Пол")
    static let genderFemale = NSLocalizedString("Женский", comment: "Пол")

    static let unknown = NSLocalizedString("Неизвестно", comment: "Незивестное значение")

    static let format_N_of_M = NSLocalizedString("%ld из %ld", comment: "N из M")

    static let yes = NSLocalizedString("ДА", comment: "Позитивный ответ")
    static let no = NSLocalizedString("НЕТ", comment: "Негативный ответ")

    static let normalScorePlaceholder = "-"
}
