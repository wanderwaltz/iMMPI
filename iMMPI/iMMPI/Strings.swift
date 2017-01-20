import Foundation

enum Strings {
    // MARK: - Screens
    enum Screen {
        static let newRecord = NSLocalizedString("Новая запись", comment: "Заголовок экрана создания записи")
        static let editRecord = NSLocalizedString("Редактировать запись",
                                                  comment: "Заголовок экрана редактирования записи")

        static let trash = NSLocalizedString("Корзина", comment: "Заголовок экрана корзины")
        static let analysisOptions = NSLocalizedString("Настройки", comment: "Заголовок экрана настроек анализа")
        static let print = NSLocalizedString("Печать", comment: "Заголовок экрана печати")
    }


    // MARK: - Buttons
    static let records = NSLocalizedString("Записи", comment: "Кнопка перехода ко всем записям")
    static let answers = NSLocalizedString("Ответы", comment: "Кнопка перехода на экран ответов")
    static let print = NSLocalizedString("Печать", comment: "Кнопка перехода к опциям печати")
    static let delete = NSLocalizedString("Удалить", comment: "Кнопка удаления")

    static let filterResults = NSLocalizedString("Фильтр значений", comment: "Опция анализа")
    static let hideNormalResults = NSLocalizedString("Скрыть норму", comment: "Опция анализа")


    // MARK: - Forms
    static let formPersonName = NSLocalizedString("ФИО", comment: "Поле 'ФИО' формы редактирования записи")

    static let formPersonNamePlaceholder =
        NSLocalizedString("Иванов Иван Иванович",
                          comment: "Плейсхолдер поля 'ФИО' формы редактирования записи")

    static let formGender = NSLocalizedString("Пол", comment: "Поле 'Пол' формы редактирования записи")

    static let formAgeGroup =
        NSLocalizedString("Возрастная группа", comment: "Поле 'Возрастная группа' формы редактирования записи")

    static let formDate =
        NSLocalizedString("Дата тестирования", comment: "Поле 'Дата тестирования' формы редактирования записи")


    static let ageGroupAdult = NSLocalizedString("Взрослая", comment: "Название возрастной группы")
    static let ageGroupTeen = NSLocalizedString("Подростковая", comment: "Название возрастной группы")

    static let genderMale = NSLocalizedString("Мужской", comment: "Пол")
    static let genderFemale = NSLocalizedString("Женский", comment: "Пол")

    static let unknown = NSLocalizedString("Неизвестно", comment: "Незивестное значение")


    // MARK: - Analysis
    static let format_N_of_M = NSLocalizedString("%ld из %ld", comment: "N из M")

    static let yes = NSLocalizedString("ДА", comment: "Позитивный ответ")
    static let no = NSLocalizedString("НЕТ", comment: "Негативный ответ")

    static let normalScorePlaceholder = "-"


    // MARK: - Reports
    static let reportOverall = NSLocalizedString("Анализ (все шкалы)", comment: "Название общего отчета по анализу")
}
